# Veldspar EVE Online API Client
# data-user.coffee - User related data
# Copyright © Denis Luchkin-Zhou
Veldspar = (exports ? this).Veldspar
UserData = Veldspar.UserData
Cache = Veldspar.Cache

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

# Publish standing data
Meteor.publish 'user.NpcStandings', (charid) ->
  char = UserData.characters.findOne _id:charid
  if char and (char.owner is this.userId)
    return UserData.npcStandings.find 'charId': charid
  else
    this.ready()

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
  charInfo = Veldspar.API.Eve.getCharacterInfo char.apiKey, char.id

  # Resolve employment history
  employerNames = Veldspar.Cache.resolveEntityNames _.map(charInfo.employmentHistory, (i)->i.corp.id)
  for employer in charInfo.employmentHistory
    employer.corp.name = employerNames[employer.corp.id].name

  # Merge charInfo into charSheet
  _.extend charSheet, _.pick charInfo, 'employmentHistory', 'ship', 'location', 'securityStatus', 'corp'

  # Convert skill array into a skill hash for faster lookup
  charSheet.skills = _.indexBy charSheet.skills, 'id'

  # Compute total character skill points
  charSheet.skillPoints = _(charSheet.skills).pluck('sp').reduce(((memo, num) -> memo + num), 0)

  # Resolve basic skill information
  for id, s of charSheet.skills
    skill = Veldspar.StaticData.skillTree.findOne({_id:String(s.id)}) ?
      name: 'UNKNOWN'
      rank: 1
      attributes:
        primary: 'intelligence'
        secondary: 'memory'
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

UserData.updateNpcStandings = (id) ->
  ###
  Entry ID generation:
    CharID + '.' + Entity ID
  ###

  console.log 'UserData.updateNpcStandings()'

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
  cacheTimer = Cache.timers.findOne(charId: char.id, method: 'npc-standings')

  if cacheTimer?.timer and cacheTimer.timer >= Veldspar.Timing.eveTime()
    console.log 'Cache timer in effect until ' + cacheTimer.timer
    return

  # Fetch standings from CCP
  standings = Veldspar.API.Character.getNpcStandings char.apiKey, char.id

  # Update the cache timer
  if cacheTimer
    Cache.timers.update {_id: cacheTimer._id}, {$set: {timer: standings._cachedUntil}}
  else
    Cache.timers.insert charId: char.id, method: 'npc-standings', timer: standings._cachedUntil


  # Update standings
  for agent in standings.agents
    _id = char.id + '.' + agent.id
    UserData.npcStandings.update {_id:_id},
      {$set: {id:agent.id, name:agent.name, standing:agent.standing, type: 'agent',  charId: char._id}}, {upsert: yes}
  for corp in standings.corps
    _id = char.id + '.' + corp.id
    UserData.npcStandings.update {_id:_id},
      {$set: {id:corp.id, name:corp.name, standing:corp.standing, type: 'corp', charId: char._id}}, {upsert: yes}
  for faction in standings.factions
    _id = char.id + '.' + faction.id
    UserData.npcStandings.update {_id:_id},
      {$set: {id:faction.id, name:faction.name, standing:faction.standing, type: 'faction', charId: char._id}}, {upsert: yes}
