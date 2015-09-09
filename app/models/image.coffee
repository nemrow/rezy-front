`import DS from 'ember-data'`

Image = DS.Model.extend {
  url: DS.attr 'string'
  place: DS.belongsTo 'place'
}

`export default Image`
