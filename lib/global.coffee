# Veldspar EVE Online API Client
# global.coffee - Namespace definitions & configuration
# Copyright © Denis Luchkin-Zhou

# Global scope
root = exports ? this

# Application namespace definition
root = root.Veldspar ?= { }

# Veldspar configuration namespace
config = root.Config ?= { }

# EVE API server protocol and hostname
config.apiHost = 'https://api.eveonline.com'
config.apiHost = 'http://localhost:8888'
#config.apiHost = 'https://api.testeveonline.com'
config.imageHost = 'http://images.eveonline.com'
config.imageHost = 'http://localhost:8888'

# Indicates whether to log detailed request and response parameters
config.verbose = yes

# Indicates whether to hide unpublished entities from clients
config.hideUnpublished = no


# Client-side helpers
if Meteor.isClient
  UI.registerHelper 'session', (name) -> Session.get name
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
