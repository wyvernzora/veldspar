# Veldspar EVE Online API Client
# data-static.coffee - Static EVE data
# Copyright © Denis Luchkin-Zhou

# Global scope & application root
root = (exports ? this).Veldspar ?= { }
# Static data namespace
root.StaticData ?= { }

# Skills & Certificates
root.StaticData.skills = new Meteor.Collection 'static.skills'
root.StaticData.certificates = new Meteor.Collection 'static.certificates'

root.StaticData.properties = new Meteor.Collection 'static.properties'
root.StaticData.marketGroups = new Meteor.Collection 'static.markerGroups'
root.StaticData.types = new Meteor.Collection 'static.types'

# Subscribe to data on clients
if Meteor.isClient
  Meteor.subscribe 'static.skills'
  Meteor.subscribe 'static.certificates'

  Meteor.subscribe 'static.properties'
  Meteor.subscribe 'static.marketGroups'
  Meteor.subscribe 'static.types'
