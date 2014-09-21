# Veldspar EVE Online API Client
# static-data-import.coffee - Utility methods for updating static data
# Copyright © Denis Luchkin-Zhou
Veldspar = (exports ? this).Veldspar
StaticData = Veldspar.StaticData

# Publish all static data
Meteor.publish 'static.skills', -> StaticData.skills.find()
Meteor.publish 'static.certificates', -> StaticData.certificates.find()

Meteor.publish 'static.properties', -> StaticData.properties.find()
Meteor.publish 'static.marketGroups', -> StaticData.marketGroups.find()
Meteor.publish 'static.types', -> StaticData.types.find()
