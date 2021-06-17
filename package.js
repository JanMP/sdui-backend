Package.describe({
  name: 'sdui-backend',
  version: '0.0.1',
  // Brief, one-line summary of the package.
  summary: '',
  // URL to the Git repository containing the source code for this package.
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('2.2');
  api.use('coffeescript');
  api.use('coagmano:stylus');
  api.use('ecmascript');
  api.use('alanning:roles');
  api.use('mdg:validated-method');
  api.use('momentjs:moment');
  api.use('peerlibrary:reactive-publish')
  api.use('tunguska:reactive-aggregate');
  api.mainModule('sdui-backend.js');
});

Package.onTest(function(api) {
  api.use('coffeescript');
  api.use('ecmascript');
  api.use('tinytest');
  api.use('sdui-backend');
  api.mainModule('sdui-backend-tests.js');
});