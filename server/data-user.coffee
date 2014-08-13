# Veldspar EVE Online API Client
# data-user.coffee - User related data
# Copyright © Denis Luchkin-Zhou
Veldspar = (exports ? this).Veldspar
UserData = Veldspar.UserData

# Server-only Data
UserData.callLog = new Meteor.Collection 'user.CallLog'

# Publish User Info
Meteor.publish 'user.Config', ->
  return Meteor.users.find(_id:this.userId, {fields: {isAdmin:1, config: 1}}) if @userId
  @ready()

# Publish Character Data
Meteor.publish 'user.Characters', ->
  # For the increased security and possible future implementation of character
  # sharing feature, API Keys should never be visible on the client side of the
  # application.
  return UserData.characters.find({owner: this.userId}, {fields: {apiKey: 0}}) if @userId
  @ready()

Meteor.publish 'user.SkillQueue', ->
  return UserData.skillQueue.find({owner: this.userId}) if @userId
  @ready()


# Utility methods
UserData.updateCharacterSheet = (id) ->
  # Cannot do this if no user logged in
  if not Meteor.userId()
    throw new Meteor.Error 403, 'Access denied: active user required.'
  userid = Meteor.userId() # Cache user id
  # Check against cache timer
  lastCall = UserData.callLog.findOne({'char': id, 'method': 'get-char-sheet'})
  if lastCall and lastCall.cachedUntil >= Veldspar.Timing.eveTime()
    console.log 'Cache timer in effect, skipping'
  else
    char = UserData.characters.findOne({'owner': userid, '_id': id})
    if char
      charSheet = Veldspar.API.Character.getCharacterSheet char.apiKey, char.id
      # Sort character skills to speed up future searches
      charSheet.skills.sort (a, b) -> a.id - b.id
      char.skillPoints = _(charSheet.skills).pluck('sp').reduce(((memo, num) -> memo + num), 0)
      # Update character info from the character sheet
      _.extend char, _.omit charSheet, '_currentTime', '_cachedUntil', 'id', 'name'
      UserData.characters.update({'_id': id}, char)
      UserData.callLog.upsert({'char': id, 'method': 'get-char-sheet'}, {$set: {'cachedUntil': char._cachedUntil}})

UserData.updateSkillInTraining = (id) ->
  console.log 'update-skill-in-training'
  # Cannot do this if no user logged in
  if not Meteor.userId()
    throw new Meteor.Error 403, 'Access denied: active user required.'
  userid = Meteor.userId() # Cache user id
  # Check against cache timer
  lastCall = UserData.callLog.findOne({'char': id, 'method': 'get-skill-in-training'})
  if lastCall and lastCall.cachedUntil >= Veldspar.Timing.eveTime()
    console.log 'Cache timer in effect, skipping'
  else
    char = UserData.characters.findOne({'owner': userid, '_id': id})
    if char
      skillInfo = Veldspar.API.Character.getSkillInTraining char.apiKey, char.id
      UserData.callLog.update({'char': id, 'method': 'get-skill-in-training'}, {$set: {'cachedUntil': char._cachedUntil}})
      UserData.characters.update({'_id': id}, {$set: {'skillInTraining': _.omit(skillInfo, '_currentTime', '_cachedUntil')}})

UserData.updateSkillQueue = (id) ->
  # Cannot do this if no user logged in
  if not Meteor.userId()
    throw new Meteor.Error 403, 'Access denied: active user required.'
  userid = Meteor.userId() # Cache user id
  # Check against cache timer
  lastCall = UserData.callLog.findOne({'char': id, 'method': 'get-skill-queue'})
  if lastCall and lastCall.cachedUntil >= Veldspar.Timing.eveTime()
    console.log 'Cache timer in effect, skipping'
  else
    char = UserData.characters.findOne({'owner': userid, '_id': id})
    if char
      skillQueue = Veldspar.API.Character.getCharacterSheet char.apiKey, char.id
      # Update character info from the character sheet
      _.extend char, _.omit charSheet, '_currentTime', '_cachedUntil', 'id', 'name', 'skills'
      UserData.characters.update({'owner': userid, '_id': id}, char)
      UserData.callLog.update({'char': id, 'method': 'get-char-sheet'}, {'cachedUntil': char._cachedUntil}, true)
      # Update skill information from the character sheet
      _.each charSheet.skills, (skill) ->
        _.extend skill, owner: userid, char: id
        UserData.skills.upsert({'owner': userid, 'char': char.id, 'id': skill.id},
          skill)
