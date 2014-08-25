# Veldspar EVE Online API Client
# methods-data.coffee - Database updating methods
# Copyright © Denis Luchkin-Zhou
Veldspar = (exports ? this).Veldspar
# Data namespaces
StaticData = Veldspar.StaticData
UserData = Veldspar.UserData

# Utility Methods
applyToChar = (id, f) ->
  if not Meteor.userId()
    throw new Meteor.Error 403, 'Access denied.'
  if id then f id
  else
    chars = UserData.characters.find({owner: Meteor.userId(), type: 'Character'});
    _.each chars.fetch(), (i) -> f i._id

# Meteor methods
Meteor.methods
  # User Info Update
  'data.updateCharacterSheet': (id) ->
    @unblock()
    applyToChar id, UserData.updateCharacterSheet

  'data.updateSkillInTraining': (id) ->
    @unblock()
    applyToChar id, UserData.updateSkillInTraining

  'data.updateSkillQueue': (id) ->
    @unblock()
    applyToChar id, UserData.updateSkillQueue

  # View-specific updates
  'data.updateUserView': ->
    @unblock()
    applyToChar null, (id) ->
      UserData.updateCharacterSheet id
      UserData.updateSkillInTraining id

  
