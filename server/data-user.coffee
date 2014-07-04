# Veldspar EVE Online API Client
# data-user.coffee - User related data
# Copyright © Denis Luchkin-Zhou
Veldspar = (exports ? this).Veldspar
UserData = Veldspar.UserData

# Publish relevant user data
Meteor.publish 'user_Users', ->
  if this.userId
    return Meteor.users.find {_id: this.userId}, 
      {fields: { isAdmin: 1, apiKeys: 1 }}
  else
    this.ready()

# Publish Api Key Data
Meteor.publish 'user_ApiKeys', ->
  if this.userId
    return UserData.apiKeys.find({owner: this.userId})
  else
    this.ready()
  
# Add default fields to the user on creation
Accounts.onCreateUser (options, user) ->
  user.isAdmin = false
  user.apiKeys = [ ]
  return user