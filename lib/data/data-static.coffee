# Veldspar EVE Online API Client
# data-static.coffee - Static EVE data
# Copyright © Denis Luchkin-Zhou

# Global scope & application root
root = (exports ? this).Veldspar ?= { }
# Static data namespace
root.StaticData ?= { }

# Skills & Certificates
root.StaticData.skillCategories = new Meteor.Collection 'static.SkillCategories'
root.StaticData.skillTree = new Meteor.Collection 'static.SkillTree'
root.StaticData.certificates = new Meteor.Collection 'static.Certificates'

root.StaticData.properties = new Meteor.Collection 'static.Properties'
root.StaticData.marketGroups = new Meteor.Collection 'static.MarkerGroups'
root.StaticData.types = new Meteor.Collection 'static.Types'

# Subscribe to data on clients
if Meteor.isClient
  Meteor.subscribe 'static.SkillCategories'
  Meteor.subscribe 'static.SkillTree'
  Meteor.subscribe 'static.Certificates'

  Meteor.subscribe 'static.Properties'
  Meteor.subscribe 'static.MarketGroups'
  Meteor.subscribe 'static.Types'
