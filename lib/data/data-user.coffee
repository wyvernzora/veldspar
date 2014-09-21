# Veldspar EVE Online API Client
# data-user.coffee - User related data
# Copyright © Denis Luchkin-Zhou

# Global scope & application root
root = (exports ? this).Veldspar ?= { }
# User data namespace
root.UserData ?= { }


# Character sheet & such
root.UserData.characters = new Meteor.Collection 'user.characters',
  # Attach utility functions to the document
  transform: (c) ->
    c.getSkill = (id) -> c.skills[String(id)]
    return c
# Skills
root.UserData.skills = new Meteor.Collection 'user.skills'
# Skill Queue
root.UserData.skillQueue = new Meteor.Collection 'user.skillQueue'
# NPC Standings
root.UserData.npcStandings = new Meteor.Collection 'user.npcStandings'

if Meteor.isClient
  # Subscribe to user data
  Meteor.subscribe 'user.config'      # User metadata, such as preferences
