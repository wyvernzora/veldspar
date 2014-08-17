# Veldspar EVE Online API Client
# data-user.coffee - User related data
# Copyright © Denis Luchkin-Zhou

# Global scope & application root
root = (exports ? this).Veldspar ?= { }
# User data namespace
root.UserData ?= { }


# Character Registry
root.UserData.characters = new Meteor.Collection 'user.Characters',
  # Attach utility functions to the document
  transform: (c) ->
    c.getSkill = (id) -> c.skills[String(id)]
    return c
root.UserData.skillQueue = new Meteor.Collection 'user.SkillQueue'

if Meteor.isClient
  # Subscribe to user data
  Meteor.subscribe 'user.Config'      # User metadata, such as preferences
  Meteor.subscribe 'user.Characters'  # Character data, not including skills
  Meteor.subscribe 'user.SkillQueue'  # Skill queue
