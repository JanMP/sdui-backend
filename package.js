Package.describe({
  name: 'janmp:sdui-backend',
  version: '0.0.1',
  // Brief, one-line summary of the package.
  summary: 'backend part of SchemaDrivenUI for meteor',
  // URL to the Git repository containing the source code for this package.
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Npm.depends({});

Package.onUse(function (api) {
  api.versionsFrom('2.3');
  api.use('coffeescript');
  api.use('coagmano:stylus');
  api.use('ecmascript');
  api.use('typescript')
  api.use('alanning:roles');
  api.use('mdg:validated-method');
  api.use('momentjs:moment');
  api.use('peerlibrary:reactive-publish');
  api.use('tunguska:reactive-aggregate');
  api.use('janmp:sdui-rolechecks');
  api.mainModule('sdui-backend.js');
});

Package.onTest(function (api) {
  api.use('coffeescript');
  api.use('ecmascript');
  api.use('tinytest');
  api.use('janmp:sdui-backend');
  api.mainModule('sdui-backend-tests.js');
});
