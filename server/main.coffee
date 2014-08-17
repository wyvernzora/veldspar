# Veldspar EVE Online API Client
# main.coffee - Meteor method definitions
# Copyright © Denis Luchkin-Zhou
Veldspar = (exports ? this).Veldspar
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


# Server Methods
Meteor.methods {

  # Administrative Methods

  # Updates the skill tree from API
  updateStaticData: ->
    if Meteor.user()?.isAdmin
      #StaticData.updateSkillTree() # Skill tree is updated via API
      StaticData.updateCertificates() # Certificates are updated from .yaml file
    else
      throw new Meteor.Error 403, 'Access denied: administrator account required.'



  updateSkillTree: () ->
    if Meteor.user() and Meteor.user().isAdmin
      StaticData.updateSkillTree()
    else
      throw new Meteor.Error 403, 'Access denied.'

  # OP/deOP a user
  setAdminFlag: (userId, flag) ->
    if Meteor.user() and Meteor.user().isAdmin
      Meteor.users.update({_id: userId}, {$set: {isAdmin: flag}})
    else
      throw new Meteor.Error 403, 'Access denied.'

  # API Call Proxy Methods
  getApiKeyInfo: (id, vcode) ->
    check(id, Number)
    check(vcode, String)
    this.unblock()
    apiKey = Veldspar.API.Account.getApiKeyInfo 'id': id, 'code': vcode
    apiKey.id = id
    apiKey.code = vcode
    return apiKey


  # User Info Update
  updateCharacterSheet: (id) ->
    @unblock()
    applyToChar id, UserData.updateCharacterSheet
  updateSkillInTraining: (id) ->
    @unblock()
    applyToChar id, UserData.updateSkillInTraining
  updateSkillQueue: (id) ->
    @unblock()
    applyToChar id, UserData.updateSkillQueue

  # View-specific updates
  updateUserView: ->
    @unblock()
    applyToChar null, (id) ->
      UserData.updateCharacterSheet id
      UserData.updateSkillInTraining id

  # Debug Methods
  debug: ->
    if Meteor.user() and Meteor.user().isAdmin
      char = JSON.parse Assets.getText 'ayase.apikey.json'
      return Veldspar.API.Character.getCharacterSheet char, char.characterID
    else
      throw new Meteor.Error 403, 'Access denied.'
}
