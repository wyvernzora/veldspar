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
  console.log 'UserData.updateCharacterSheet()'

  # Cannot do this if no user is logged in
  if not Meteor.userId()
    throw new Meteor.Error 403, 'Access denied: active user required.'
  userid = Meteor.userId() # Cache user id

  # Find current character data and make sure there is such
  char = UserData.characters.findOne({'owner': userid, '_id': id})
  if not char
    console.log 'Character not found!'
    return

  # Skip the update if cache is still valid
  if char._cachedUntil and char._cachedUntil >= Veldspar.Timing.eveTime()
    console.log 'Cache timer in effect until ' + char._cachedUntil
    return

  # Start the update by getting the most recent character sheet
  charSheet = Veldspar.API.Character.getCharacterSheet char.apiKey, char.id

  # Convert skill array into a skill hash for faster lookup
  charSheet.skills = _.indexBy charSheet.skills, 'id'

  # Compute total character skill points
  charSheet.skillPoints = _(charSheet.skills).pluck('sp').reduce(((memo, num) -> memo + num), 0)

  # Resolve basic skill information
  for id, s of charSheet.skills
    skill = Veldspar.StaticData.skillTree.findOne({_id:String(s.id)})
    _.extend s, _.pick skill, 'name', 'rank', 'attributes'
    s.groupID = skill.group.id

  # Calculate certificate levels from skills
  charSheet.certificates = { }
  for cert in Veldspar.StaticData.certificates.find().fetch()
    skillLevels = []
    # Get skill levels for the character
    for skill in cert.skills
      #l = char.getSkill(skill.id)?.level ? 0
      l = charSheet.skills[skill.id]?.level ? 0
      for i in [0..5]
        x = i if skill.levels[i] <= l
      skillLevels.push x
    # Calculate actual certificate level
    charSheet.certificates[cert._id] = _.min skillLevels

  # Update character info from the character sheet
  UserData.characters.update({'_id': char._id}, {$set: _.omit(charSheet, '_currentTime', 'id', 'name') })

UserData.updateSkillInTraining = (id) ->
  console.log 'UserData.updateSkillInTraining()'

  # Cannot do this if no user is logged in
  if not Meteor.userId()
    throw new Meteor.Error 403, 'Access denied: active user required.'
  userid = Meteor.userId() # Cache user id

  # Find current character data and make sure there is such
  char = UserData.characters.findOne({'owner': userid, '_id': id})
  if not char
    console.log 'Character not found!'
    return

  # Skip the update if cache is still valid
  if char?.skillInTraining?._cachedUntil and char?.skillInTraining?._cachedUntil >= Veldspar.Timing.eveTime()
    console.log 'Cache timer in effect until ' + char.skillInTraining._cachedUntil
    return

  # Get the info about the skill in training
  skillInfo = Veldspar.API.Character.getSkillInTraining char.apiKey, char.id
  UserData.characters.update({'_id': char._id}, {$set: {'skillInTraining': _.omit(skillInfo, '_currentTime')}})

UserData.updateSkillQueue = (id) ->
  console.log 'UserData.updateSkillQueue()'

  # Cannot do this if no user is logged in
  if not Meteor.userId()
    throw new Meteor.Error 403, 'Access denied: active user required.'
  userid = Meteor.userId() # Cache user id

  # Find current character data and make sure there is such
  char = UserData.characters.findOne({'owner': userid, '_id': id})
  if not char
    console.log 'Character not found!'
    return

  # Skip the update if cache is still valid
  if char?.skillQueue?._cachedUntil and char?.skillQueue?._cachedUntil >= Veldspar.Timing.eveTime()
    console.log 'Cache timer in effect until ' + char.skillQueue._cachedUntil
    return

  # Get the skill queue information
  response = Veldspar.API.Character.getSkillQueue char.apiKey, char.id
  console.log response

  # Convert the skill queue into an object
  response.skillQueue = _.indexBy response.skillQueue, 'position'
  response.skillQueue._cachedUntil = response._cachedUntil # Add cache information
  UserData.characters.update({'_id': char._id}, {$set: {'skillQueue': response.skillQueue}})
