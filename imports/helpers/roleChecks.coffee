import {Meteor} from 'meteor/meteor'
import {Roles} from 'meteor/alanning:roles'
import {useTracker} from 'meteor/react-meteor-data'

# use in subscriptions
export userWithIdIsInRole = ({role, id}) ->
  switch role
    when 'any'
      true
    when 'logged-in'
      id?
    else
      Roles.userIsInRole id, role
    
export currentUserIsInRole = (role) -> userWithIdIsInRole id: Meteor.userId(), role: role

#for use in React Components
export useCurrentUserIsInRole = (role) -> useTracker -> currentUserIsInRole role

#throws if not in role, for use in Meteor.method
export currentUserMustBeInRole = (role) ->
  unless currentUserIsInRole role
    throw new Meteor.Error "user must be in role #{role}"