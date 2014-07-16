# Veldspar EVE Online API Client
# main.coffee - Meteor method definitions
# Copyright © Denis Luchkin-Zhou
Veldspar = (exports ? this).Veldspar
StaticData = Veldspar.StaticData
UserData = Veldspar.UserData

# Server Methods
Meteor.methods {
  
  # Administrative Methods
  
  # Returns a value indicating whether current user
  # is an administrator
  isAdmin: () ->
    if Meteor.user()
      Meteor.user().isAdmin
    else
      no
  
  # Updates the skill tree from API
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
  
  
  # Debug Methods
  test: ->
    char = JSON.parse Assets.getText 'ayase.apikey.json'
    #charSheet = Veldspar.API.Character.getCharacterSheet char, char.characterID
    
    raw = Veldspar.StaticData.updateSkillTree()
    return raw
    # Get skill tree
}