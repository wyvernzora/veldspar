# Veldspar EVE Online API Client
# data-user.coffee - User related data
# Copyright © Denis Luchkin-Zhou

# Global scope & application root
root = (exports ? this).Veldspar ?= { }
# User data namespace
root.UserData ?= { }

# User metadata
root.UserData.characters = new Meteor.Collection 'user_Characters'

if Meteor.isClient
  # Subscribe to user data
  Meteor.subscribe 'user_Characters'