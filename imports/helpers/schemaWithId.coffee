import SimpleSchema from 'simpl-schema'
import _ from 'lodash'

idSchema =
  new SimpleSchema
    _id: String
  , requiredByDefault: false

export default schemaWithId = (schema) -> (_.cloneDeep schema).extend idSchema