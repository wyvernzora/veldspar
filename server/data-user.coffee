# Veldspar EVE Online API Client
# data-user.coffee - User related data
# Copyright © Denis Luchkin-Zhou
Veldspar = (exports ? this).Veldspar
UserData = Veldspar.UserData


UserData.callLog = new Meteor.Collection 'user.CallLog'

# Publish Character Data
Meteor.publish 'user.Characters', ->
  if this.userId
    return UserData.characters.find({owner: this.userId})
  else
    this.ready()
    
    
    
# Utility methods
UserData.updateCharacterSheet = (id) ->
  lastCall = UserData.callLog.findOne({'char': id, 'method': 'get-char-sheet'})
  if not lastCall or lastCall.cachedUntil < Veldspar.Timing.eveTime()
    char = UserData.characters.findOne({'owner': Meteor.userId, '_id': id})
    if char
      charSheet = Veldspar.API.Character.getCharacterSheet char.apiKey, char.id
      char = _.extend(char, charSheet);
      UserData.characters.update({'owner': Meteor.userId, '_id': id}, char)
      UserData.callLog.update({'char': id, 'method': 'get-char-sheet'}, {'cachedUntil': char._cachedUntil}, true)