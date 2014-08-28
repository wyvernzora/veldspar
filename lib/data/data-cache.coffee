# Veldspar EVE Online API Client
# data-cache.coffee - Cached data
# Copyright © Denis Luchkin-Zhou
# Global scope & application root
root = (exports ? this).Veldspar ?= { }
# Static data namespace
Cache = root.Cache ?= { }


Cache.entityNames = new Meteor.Collection 'cache.EntityNames'


if Meteor.isClient
  Meteor.subscribe 'cache.EntityNames'
