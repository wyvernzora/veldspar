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

# Subscribe to data on clients
if Meteor.isClient
  Meteor.subscribe 'static.SkillCategories'
  Meteor.subscribe 'static.SkillTree'