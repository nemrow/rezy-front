`import DS from 'ember-data'`

Place = DS.Model.extend {
  name: DS.attr 'string'
  longitude: DS.attr 'string'
  latitude: DS.attr 'string'
  phone: DS.attr 'string'
  search: DS.belongsTo "search", async: true
  images: DS.hasMany "image", async: true
  imageUrl: Ember.computed.alias('images.firstObject.url')
  address: DS.attr 'string'
  latitude: DS.attr 'string'
  longitude: DS.attr 'string'
  international_phone: DS.attr 'string'
  website: DS.attr 'string'
  rating: DS.attr 'number'
  price: DS.attr 'number'
  place_id: DS.attr 'string'
}

`export default Place`
