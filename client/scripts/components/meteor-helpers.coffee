###!
Veldspar.io - Meteor.js based EveMon alternative
Copyright © 2014 Denis Luchkin-Zhou
-------------------------------------------------------------------------------
meteor-helpers-data.coffee - Data access for Spacebars.js
###

# =============================================================================
#   Session variable access
# =============================================================================
UI.registerHelper 'session', (name) -> Session.get name
UI.registerHelper 'sessionIs', (name, value) -> Session.equals name, value

# =============================================================================
#   Application state data
# =============================================================================
UI.registerHelper 'routerParam', (name) ->
  Router.current()?.params[name]

# =============================================================================
#   Formatting
# =============================================================================

# Converts the number into it's B, M, K equivalent.
UI.registerHelper 'millionize', (number, decimals) ->
  decimals = 1 if not _.isNumber decimals
  c = Math.pow(10, decimals)
  return Math.floor(number / 1000000000 * c) / c + 'B' if number >= 1000000000
  return Math.floor(number / 1000000 * c) / c + 'M' if number >= 1000000
  return Math.floor(number / 1000 * c) / c + 'K' if number >= 1000
  return number

# Converts the number into the roman numeral.
UI.registerHelper 'romanize', (number) ->
  if not number then return ''
  digits = String(+number).split("")
  key = ["","C","CC","CCC","CD","D","DC","DCC","DCCC","CM",
         "","X","XX","XXX","XL","L","LX","LXX","LXXX","XC",
         "","I","II","III","IV","V","VI","VII","VIII","IX"]
  roman = ""
  i = 3
  while (i--)
    roman = (key[+digits.pop() + (i * 10)] || "") + roman
  return Array(+digits.join("") + 1).join("M") + roman

# Inserts delimiters into the number
UI.registerHelper 'delimit', (num, delimiter) ->
  delimiter = '\'' if not _.isString(delimiter)
  return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, delimiter)

# Fixes the number of decimal digits
UI.registerHelper 'fixDecimals', (num, decimals) ->
  return (Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals)).toFixed(decimals);

# Helper for the Numeral.js package
UI.registerHelper 'numeral', (num, format) ->
  return if not num
  format = '0' if not _.isString(format)
  return numeral(num).format(format)


# Converts the string to lower case
UI.registerHelper 'lower', (str) -> return str.toLowerCase()

# Converts the timespan object into string
UI.registerHelper 'timespan', (timespan) ->
  list = [] # Faster than concateration
  # Push timespans
  list.push timespan.day + 'd'
  list.push timespan.hour + 'h'
  list.push timespan.minute + 'm'
  list.push timespan.second + 's'
  # Remove entries until first non-zero value
  return list.join ' '

# =============================================================================
#   Database access utilities
# =============================================================================

# Gets the first email address of the active user
UI.registerHelper 'userEmail', ->
  Meteor.user().emails[0].address

# Gets the skill info
UI.registerHelper 'skill', (id) ->
  Veldspar.StaticData.skills.findOne _id:String id


# =============================================================================
#   Graphics
# =============================================================================

# Gets the portrait URI of an entity
# ! MUST be called from a {character} or {corporation} context
UI.registerHelper 'portrait', (size, type) ->
  t = if _.isString(type) then type else @type
  # Normalize the size to one of the officially supported resolutions
  size = Math.pow 2, ((x) ->
    exp = Math.ceil (Math.LOG2E * Math.log x)
    exp = 5 if exp < 5
    exp = 9 if exp > 9
    exp
  )(size)
  format = if t is 'Character' then 'jpg' else 'png'
  # Construct the URI
  return _.template '<%= host %>/<%= type %>/<%= id %>_<%= size %>.<%= ext %>',
    host: Veldspar.Config.imageHost, id: @id, size: size, type: t, ext: format


# Gets the icon for a skill
###
UI.registerHelper 'skillIcon', ->
  lv = @?.level ? 0
  if lv is 5 then '/svg/skills/book-level-v.svg'
  else if @sp isnt Veldspar.util.skill.sp(lv, @rank) then return '/svg/skills/book-partial.svg'
  else '/svg/skills/book-default.svg'
###

# =============================================================================
#   Calculations
# =============================================================================
# Gets the total SP for the specified skill rank and level
UI.registerHelper 'sp', (rank, level) ->
  return Veldspar.util.skill.sp level, rank

# Gets the number of SP per hour a character trains for the given skill
UI.registerHelper 'sph', (char, skill) ->
  return Veldspar.util.skill.spm(char, skill) * 60
