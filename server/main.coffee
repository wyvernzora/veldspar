# Veldspar EVE Online API Client
# main.coffee - Meteor method definitions
# Copyright © Denis Luchkin-Zhou
Veldspar = (exports ? this).Veldspar
StaticData = Veldspar.StaticData

# Server Methods
Meteor.methods {
  
  getApiKeyInfo: (id, vcode) ->
    check(id, Number)
    check(vcode, String)
    this.unblock();
    apiKey = Veldspar.API.Account.getApiKeyInfo 'id': id, 'code': vcode
    apiKey.id = id
    apiKey.code = vcode
    return apiKey
  
  test: ->
    char = JSON.parse Assets.getText 'ayase.apikey.json'
    #charSheet = Veldspar.API.Character.getCharacterSheet char, char.characterID
    
    raw = Veldspar.StaticData.updateSkillTree()
    return raw
    # Get skill tree
}