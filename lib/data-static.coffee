# Veldspar EVE Online API Client
# data-static.coffee - Static EVE data
# Copyright © Denis Luchkin-Zhou

# Global scope & application root
root = (exports ? this).Veldspar ?= { }
# Static data namespace
root.StaticData ?= { }

# Skills & Certificates
root.StaticData.skillCategories = new Meteor.Collection 'static_SkillCategories'
root.StaticData.skillTree = new Meteor.Collection 'static_SkillTree'

# Subscribe to data on clients
if Meteor.isClient
  Meteor.subscribe 'static_SkillCategories'
  Meteor.subscribe 'static_SkillTree'