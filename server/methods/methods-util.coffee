# Veldspar EVE Online API Client
# methods-util.coffee - Utilities
# Copyright © Denis Luchkin-Zhou
Veldspar = (exports ? this).Veldspar
# Data namespaces
StaticData = Veldspar.StaticData
UserData = Veldspar.UserData


Meteor.methods

  # Internal: method for calibration of client-side timer
  'util.getTimerCalibration': ->
    Veldspar.Timing.eveTime()

  # API Call Proxy Methods
  'util.getApiKeyInfo': (id, vcode) ->
    check(id, Number)
    check(vcode, String)
    this.unblock()
    apiKey = Veldspar.API.Account.getApiKeyInfo 'id': id, 'code': vcode
    apiKey.id = id
    apiKey.code = vcode
    return apiKey
