# Veldspar EVE Online API Client
# api-methods-char.coffee - Character related API method calls
# Copyright © Denis Luchkin-Zhou
Veldspar = (exports ? this).Veldspar
Veldspar.API ?= { }
# Account related API methods
Server = Veldspar.API.Server ?= { }
# Public: Gets the server status.
#
# Returns an {Object} containing the server status info.
Server.getServerStatus       = ->
  client = new Veldspar.ApiClient '/server/ServerStatus.xml.aspx'
  transform =
    '_currentTime': 'date:eveapi.currentTime'
    '_cachedUntil': 'date:eveapi.cachedUntil'
    'open': 'bool:eveapi.result.serverOpen'
    'playerCount': 'number:eveapi.result.onlinePlayers'
  return client
    .transform(transform)
    .request()
