`import Ember from 'ember';`
`import config from './config/environment';`

Router = Ember.Router.extend
  location: config.locationType

Router.map ->
  @route 'main', path: ''
  @route 'search', path: 'search/:searchId'

`export default Router;`
