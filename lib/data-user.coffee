# Veldspar EVE Online API Client
# data-user.coffee - User related data
# Copyright © Denis Luchkin-Zhou

# Global scope & application root
root = (exports ? this).Veldspar ?= { }
# User data namespace
root.UserData ?= { }

# User metadata
root.UserData.users = new Meteor.Collection 'user_Users'
root.UserData.apiKeys = new Meteor.Collection 'user_ApiKeys'

if Meteor.isClient
  # Subscribe to user data
  Meteor.subscribe 'user_Users'
  Meteor.subscribe 'user_ApiKeys'