// Import Tinytest from the tinytest Meteor package.
import { Tinytest } from "meteor/tinytest";

// Import and rename a variable exported by sdui-backend.js.
import { name as packageName } from "meteor/sdui-backend";

// Write your tests here!
// Here is an example.
Tinytest.add('sdui-backend - example', function (test) {
  test.equal(packageName, "sdui-backend");
});
