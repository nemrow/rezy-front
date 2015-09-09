`import Ember from 'ember'`

MainController = Ember.Controller.extend
  latitude: null
  longitude: null
  boozType: null
  placesCount: 0
  currentRadius: 200
  latLng: null
  map: null
  placesService: null
  search: null
  searching: false
  userCountry: null
  cannotFindLocation: false

  places: (->
    if @get('search')
      @get('search.places')
  ).property('search.places')

  getPlacesService: (context) ->
    unless context.get('placesService')
      context.set 'placesService', new google.maps.places.PlacesService(context.getMap(context))
    @get('placesService')

  getLatLng: (context) ->
    unless context.get('latLng')
      context.set 'latLng', new google.maps.LatLng(context.get('latitude'), context.get('longitude'))
    context.get('latLng')

  getMap: (context) ->
    unless context.get('map')
      context.set 'map', new google.maps.Map($('.map')[0], {center: context.getLatLng(context), zoom: 15})
    context.get('map')

  isInUnitedStates: (->
    if @get('userCountry')
      @get('userCountry') == "United States"
  ).property('locationFound', 'userCountry')

  locationFound: (->
    @get('latitude') && @get('longitude') && @get('userCountry') != null
  ).property('latitude', 'longitude', 'userCountry')

  setLocation: (geoposition) ->
    @set 'latitude', geoposition.coords.latitude
    @set 'longitude', geoposition.coords.longitude
    geocoder = new google.maps.Geocoder()
    latlng = {lat: @get('latitude'), lng: @get('longitude')}
    geocoder.geocode {location: latlng}, (results, status) =>
      for component in results[1]["address_components"]
        if component.types.contains("country")
          @set 'userCountry', component.long_name

  init: ->
    this._super()

    # Begin geo location inquiry
    @get('geolocation').start()

    # You can use event handlers
    @get('geolocation').on 'change', (geoposition) =>
      @setLocation geoposition

    @get('geolocation').on 'error', (error) =>
      @set 'cannotFindLocation', true

    # Or you can simply do like that
    this.get('geolocation').getGeoposition().then (geoposition) =>
      @setLocation geoposition

  placesSearchComplete: ->
    @transitionTo 'search', @get('search').id

  formatNumber: (number) ->
    return false if number == undefined
    match = number.match(/\(\d{3}\) \d{3}-\d{4}/)
    if match
      match[0]
    else
      false


  createAllPlaces: (places, currentIndex) ->
    nextIndex = currentIndex + 5
    currentBatch = places.slice(currentIndex, nextIndex)
    for place in currentBatch
      @getPlacesService(this).getDetails {placeId: place.place_id}, (place, status) =>
        formatted_phone_number = @formatNumber place.formatted_phone_number
        if formatted_phone_number
          @store.createRecord("place", {
            name: place.name
            search: @get('search')
            address: place.formatted_address
            phone: formatted_phone_number
            latitude: place.geometry.G
            longitude: place.geometry.K
            international_phone: place.international_phone_number
            website: place.website
            rating: place.rating
            price: place.price_level
            place_id: place.place_id
          }).save().then (newPlace) =>
            if place.photos
              newPlace.get('images').then (images) =>
                for photo in place.photos
                  image = @store.createRecord("image", {
                    url: photo.getUrl { maxWidth: 100, maxHeight: 100 }
                    place: newPlace
                  }).save().then (image) =>
                    images.pushObject image
                    newPlace.save()
            @get('search').get('places').then (places) =>
              places.pushObject newPlace
              @get('search').save()
              @set 'placesCount', @get('placesCount') - 1
              @placesSearchComplete() if @get('placesCount') == 0
        else
          @set 'placesCount', @get('placesCount') - 1
          @placesSearchComplete() if @get('placesCount') == 0
    setTimeout =>
      @createAllPlaces(places, nextIndex) if places[nextIndex] != undefined
    , 2000

  checkDensity: (results) ->
    if @get('currentRadius') > 4828 && @get('placesCount') < 5
      alert("We cannot find enough liquor stores in your area. Move somewhere else.")
    else if @get('placesCount') < 12
    # else if @get('placesCount') < 2
      # found X places, looking for more
      setTimeout =>
        @set 'currentRadius', @get('currentRadius') + 200
        @nearbySearch()
      , 330
    else
      # X places found. We're now calling them all to look for Y!
      @createAllPlaces(results, 0)

  nearbyRequestData: ->
    location: @get('getLatLng')(this)
    radius: @get('currentRadius')
    open_now: true
    minPriceLevel: 3
    maxPriceLevel: 4
    types: ['restaurant']

  nearbySearch: ->
    @getPlacesService(this).nearbySearch @nearbyRequestData(), (results) =>
      @set "placesCount", results.length
      @checkDensity results

  actions:
    beginSearch: ->
      @set 'searching', true
      newSearch = @store.createRecord 'search', {
        partyCount: @get('partyCountde')
        latitude: @get('latitude')
        longitude: @get('longitude')
      }

      newSearch.save().then (search) =>
        @set 'search', search
        @nearbySearch()

`export default MainController`
