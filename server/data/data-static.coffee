# Veldspar EVE Online API Client
# static-data-import.coffee - Utility methods for updating static data
# Copyright © Denis Luchkin-Zhou
Veldspar = (exports ? this).Veldspar
StaticData = Veldspar.StaticData

# Publish all static data
Meteor.publish 'static.SkillTree', -> StaticData.skillTree.find()
Meteor.publish 'static.SkillCategories', -> StaticData.skillCategories.find()
Meteor.publish 'static.Certificates', -> StaticData.certificates.find()

Meteor.publish 'static.PropertyCategories', -> StaticData.propertyCategories.find()
Meteor.publish 'static.MarketGroups', -> StaticData.marketGroups.find()
Meteor.publish 'static.Types', -> StaticData.types.find()


# Security policies
StaticData.skillTree.allow {
  insert: (userId) ->
    user = Meteor.users.findOne({_id: userId});
    return (user?.isAdmin)
  update: (userId) ->
    user = Meteor.users.findOne({_id: userId});
    return (user?.isAdmin)
  remove: (userId) ->
    user = Meteor.users.findOne({_id: userId});
    return (user?.isAdmin)
  }
StaticData.skillCategories.allow {
  insert: (userId) ->
    user = Meteor.users.findOne({_id: userId});
    return (user?.isAdmin)
  update: (userId) ->
    user = Meteor.users.findOne({_id: userId});
    return (user?.isAdmin)
  remove: (userId) ->
    user = Meteor.users.findOne({_id: userId});
    return (user?.isAdmin)
  }
