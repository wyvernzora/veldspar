###!
Veldspar.io - Meteor.js based EveMon alternative
Copyright © 2014 Denis Luchkin-Zhou
-------------------------------------------------------------------------------
meteor-helpers.coffee - Global Meteor.js template helper methods
###
Veldspar.Cache = {}


# Gets the specified session variable
UI.registerHelper 'session', (name) ->
  Session.get name

# Compares the specified session variable to the specified value
UI.registerHelper 'sessionIs', (name, value) ->
  Session.equals name, value

# Gets the currently selected character
UI.registerHelper 'currentCharacter', ->
  if not Session.get('app.character') then null
  else Veldspar.UserData.characters.findOne _id:Session.get 'app.character'

# Gets the portrait URI of an entity
# ! MUST be called from a {character} or {corporation} context
UI.registerHelper 'portrait', (size) ->
  # Normalize the size to one of the officially supported resolutions
  size = Math.pow 2, ((x) ->
    exp = Math.ceil (Math.LOG2E * Math.log x)
    exp = 5 if exp < 5
    exp = 9 if exp > 9
    exp
  )(size)
  format = if @type is 'Character' then 'jpg' else 'png'
  # Construct the URI
  return _.template '<%= host %>/<%= type %>/<%= id %>_<%= size %>.<%= ext %>',
    host: Veldspar.Config.imageHost, id: @id, size: size, type: @type, ext: format

# Gets the first email of current user
UI.registerHelper 'userEmail', ->
  Meteor.user().emails[0].address

# Gets the skill info with the specified id
UI.registerHelper 'skill', (id) ->
  #if not Veldspar.Cache.skills
  #  Veldspar.Cache.skills = _.indexBy Veldspar.StaticData.skillTree.find().fetch(), '_id'
  #return Veldspar.Cache.skills[id.toString()]

  Veldspar.StaticData.skillTree.findOne(_id:String(id))

# Formats numbers into equivalent K, M, B versions
# e.g. 1000000 -> 1M
UI.registerHelper 'millionize', (number, decimals) ->
  decimals = 1 if not _.isNumber decimals
  c = Math.pow(10, decimals)
  return Math.floor(number / 1000000000 * c) / c + 'B' if number >= 1000000000
  return Math.floor(number / 1000000 * c) / c + 'M' if number >= 1000000
  return Math.floor(number / 1000 * c) / c + 'K' if number >= 1000
  return number

# Gets the total SP for the specified skill rank and level
UI.registerHelper 'sp', (rank, level) ->
  return Veldspar.util.skill.sp level, rank

# Gets the number of SP per hour a character trains for the given skill
UI.registerHelper 'sph', (char, skill) ->
  return Veldspar.util.skill.spm(char, skill) * 60

# Formats a time span into the DDd HHh MMm SSs format
UI.registerHelper 'timespan', (timespan) ->
  list = [] # Faster than concateration
  # Push timespans
  list.push timespan.day + 'd'
  list.push timespan.hour + 'h'
  list.push timespan.minute + 'm'
  list.push timespan.second + 's'
  # Remove entries until first non-zero value
  return list.join ' '

# Displays the skill level in roman numerals
UI.registerHelper 'skillLevel', (level) ->
  return ['', ' I', ' II', ' III', ' IV', ' V'][level]
