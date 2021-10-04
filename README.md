# janmp:sdui-backend and janmp:sdui-table

WIP

SchemaDrivenUI uses SimpleSchema and Uniforms to quickly set up Editable Datatables and Forms.
This package contains the Code to setup the api for Datatables.

Right now this package only supports Meteor Pub/Sub with MongoDB Aggregation Pipelines.
Code for Datafetching with Meteor methods and Pub/Sub without Aggregation Pipelines ist there,
but not recently tested.

We use alanning:roles for authorisation of different functionality. Even without any setup of
user roles we can use the roles 'any' and 'logged-in'.

To set up a table just call the function createAutoDataTableBackend with an object prop
containing the following fields:

|name|type|description|
|---|---|---|
|sourceName|String|the name of our namespace|
|sourceSchema|SimpleSchema|The SimpleSchema for the Mongodb Collection where our data lives|
|collection|Mongo.Collection|The Mongodb Collection|
|listSchema|SimpleSchema|Schema for data actually displayed in the table, defaults to sourceSchema|
|viewTableRole|String?|the role needed to view the table, defaults to 'any' (with console.warn nagging)
|useObjectIds|Boolean?|If we need to use MongoDB ObjectIds, set this to true|
|canSearch|Boolean?|set up a search field|
|canEdit|Boolean?|allows users with editRole to edit entries|
|formSchema|SimpleSchema?|The Schema used for the edit form, defaults to sourceSchema|
|editRole|String?|the role needed to edit Data, defaults to viewTableRole (nagging)|
|canAdd|Booean?|allows users with editRole to add a table entry|
|canDelete|Boolean?|allows users with editRole to delete entries|
|canExport|Boolean?|allows users with exportTableRole to download table data as csv|
|exportTableRole|String?|the role needed to export table data as csv, defaults to viewTableRole (nagging)|
|getPreSelectPipeline|()=> []|A function returning a part of the Aggregation Pipeline called before anything else|
|getProcessorPipeline|() => []| A function returning a part of the Aggregation Pipeline executed before search-string processing and sorting


The schemas can contain aditional fields for uniforms (see the uniforms documentation) and our own SDUI tables, most notably autotable: {editable: true/false} to allow editing in tables and autotable: component to use custom react components in table cells (more example code/documentation later).

## Example

In this example we set up a collection with some test data.
The table rows contain to numbers a and b. We use getProcessorPipeline to
add those numbers together and put them into a new field sum. Even though the source collection
does not conatin the sum of a and b we can search and sort by this sum.

```js
var getPreSelectPipeline, getProcessorPipeline, listSchema, testSchema;

import {
  Meteor
} from 'meteor/meteor';

import {
  Mongo
} from 'meteor/mongo';

import SimpleSchema from 'simpl-schema';

import {
  createAutoDataTableBackend
} from 'meteor/janmp:sdui-backend';

import _ from 'lodash';

SimpleSchema.extendOptions(['autotable', 'uniforms']);

export var Test = new Mongo.Collection('test');

if (Meteor.isServer) {
  if (Test.find().count() === 0) {
    (function() {
      var results = [];
      for (var i = 1; i <= 10000; i++){ results.push(i); }
      return results;
    }).apply(this).forEach(function(n) {
      return Test.insert({
        a: _.random(1, 100),
        b: _.random(1, 1000),
        name: `Test ${n}`,
        alignment: _.sample(['chaotic', 'neutral', 'lawful']),
        bool: _.sample([true, false])
      });
    });
  }
}

testSchema = new SimpleSchema({
  _id: {
    type: String,
    optional: true,
    uniforms: function() {
      return null;
    }
  },
  name: String,
  a: Number,
  b: Number,
  alignment: {
    type: String,
    allowedValues: ['chaotic', 'neutral', 'lawful']
  },
  bool: {
    type: Boolean,
    optional: true
  }
});

listSchema = new SimpleSchema({
  _id: {
    type: String,
    optional: true,
    uniforms: function() {
      return null;
    }
  },
  name: String,
  a: {
    type: Number,
    min: 5
  },
  b: {
    type: Number
  },
  sum: {
    type: Number,
    label: 'a + b'
  },
  alignment: {
    type: String,
    allowedValues: ['chaotic', 'neutral', 'lawful'],
    autotable: {
      editable: true,
      overflow: true
    }
  },
  bool: {
    type: Boolean
  }
});

getPreSelectPipeline = function() {
  return [
    {
      $match: {
        a: {
          $lt: 9
        },
        b: {
          $lt: 100
        }
      }
    }
  ];
};

getProcessorPipeline = function() {
  return [
    {
      $project: {
        _id: 1,
        name: 1,
        a: 1,
        b: 1,
        alignment: 1,
        bool: 1,
        sum: {
          $add: ['$a',
    '$b']
        }
      }
    }
  ];
};

export var props = createAutoDataTableBackend({
  sourceName: 'testList',
  sourceSchema: testSchema,
  collection: Test,
  listSchema: listSchema,
  formSchema: testSchema,
  viewTableRole: 'any',
  // getPreSelectPipeline: getPreSelectPipeline
  getProcessorPipeline: getProcessorPipeline,
  canEdit: true,
  editRole: 'any',
  canAdd: true,
  canDelete: true,
  canSearch: true,
  canExport: true
});
```

We export the return result of createAutoDataTableBackend and we just need to import
that into our react component to set up our table like this:

```js
import React from 'react';
import { MeteorDataAutoTable } from 'meteor/janmp:sdui-table';
import { props } from '/imports/api/AutoTableExample';

export const TablePage = () => (
  <div style={{height: '100vh'}}>
    <MeteorDataAutoTable {...props}/>
  </div>
)

```






