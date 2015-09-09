`import DS from 'ember-data'`

Search = DS.Model.extend {
  longitude: DS.attr 'string'
  latitude: DS.attr 'string'
  name: DS.attr 'string'
  image: DS.attr 'string'
  places: DS.hasMany "place", async: true
}

`export default Search`
