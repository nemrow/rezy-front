/* jshint node: true */

module.exports = function(environment) {
  var ENV = {
    googleMap: {
      apiKey: 'AIzaSyAz0l6x1gaD-gTHvNpEe7e31QWnl-Ob8-U',
      libraries: ['places', 'geocode']
    },
    googleFonts: [
      'Lato:700,300italic',
      'Oswald:700,300'
    ],
    modulePrefix: 'rezy-front',
    environment: environment,
    contentSecurityPolicy: {
      'connect-src': "'self' https://auth.firebase.com wss://*.firebaseio.com, *.googleusercontent.com"
    },
    firebase: 'https://rezy-production.firebaseio.com/',
    baseURL: '/',
    locationType: 'auto',
    EmberENV: {
      FEATURES: {
        // Here you can enable experimental features on an ember canary build
        // e.g. 'with-controller': true
      }
    },

    APP: {
      // Here you can pass flags/options to your application instance
      // when it is created
    }
  };

  if (environment === 'development') {
    // ENV.APP.LOG_RESOLVER = true;
    // ENV.APP.LOG_ACTIVE_GENERATION = true;
    // ENV.APP.LOG_TRANSITIONS = true;
    // ENV.APP.LOG_TRANSITIONS_INTERNAL = true;
    // ENV.APP.LOG_VIEW_LOOKUPS = true;
  }

  if (environment === 'test') {
    // Testem prefers this...
    ENV.baseURL = '/';
    ENV.locationType = 'none';

    // keep test console output quieter
    ENV.APP.LOG_ACTIVE_GENERATION = false;
    ENV.APP.LOG_VIEW_LOOKUPS = false;

    ENV.APP.rootElement = '#ember-testing';
  }

  if (environment === 'production') {

  }

  return ENV;
};
