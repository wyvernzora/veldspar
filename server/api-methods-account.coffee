# Veldspar EVE Online API Client
# api-methods-account.coffee - Account related API method calls
# Copyright © Denis Luchkin-Zhou
Veldspar = (exports ? this).Veldspar
Veldspar.API ?= { }
# Account related API methods
Account = Veldspar.API.Account ?= { }
# Public: Gets basic API key information including the key type, access mask,
# expiration data and associated characters.
#
# key -     {Object} containing API Key information
#           :id -   API Key ID
#           :code - API Key Verification Code
#
# Returns an {Object} containing the detailed information about the API Key.
Account.getApiKeyInfo = (key) ->
  client = new Veldspar.ApiClient '/account/APIKeyInfo.xml.aspx'
  transform = 
    "_currentTime": "eveapi.currentTime"
    "_cachedUntil": "eveapi.cachedUntil"
    "type": "eveapi.result.key.type"
    "accessMask": "eveapi.result.key.accessMask"
    "expires": "eveapi.result.key.expires"
    "characters":
      "$path": "eveapi.result.key.characters"
      "id": "characterID"
      "name": "characterName"
      "corp.id": "corporationID"
      "corp.name": "corporationName"
      "alliance.id": "allianceID"
      "alliance.name": "allianceName"
      "faction.id": "factionID"
      "faction.name": "factionName"
  return client.key(key).transform(transform).request()
# Public: Gets the information about the account status, including creation
# data, game time and logon statistics.
#
# key -     {Object} containing API Key Information
#           :id -         API Key ID
#           :code -       API Key Verification Code
#           :accessMask - Access mask of the API Key
#
# Returns an {Object} containing the detailed information about the account.
Account.getAccountStatus = (key) ->
  client = new Veldspar.ApiClient '/account/AccountStatus.xml.aspx'
  transform =
    '_currentTime': 'eveapi.currentTime'
    '_cachedUntil': 'eveapi.cachedUntil'
    'paidUntil': 'eveapi.result.paidUntil'
    'createDate': 'eveapi.result.createDate'
    'logonCount': 'eveapi.result.logonCount'
    'logonMinutes': 'eveapi.result.logonMinutes'
  return client.key(key).permission(33554432).transform(transform).request()
# Public: Gets the list of characters associated with the account.
#
# key -     {Object} containing API Key Information
#           :id -         API Key ID
#           :code -       API Key Verification Code
#
# Returns an {Object} containing the list of characters associated with the
# account.
Account.getCharacters = (key) ->
  client = new Veldspar.ApiClient '/account/Characters.xml.aspx'
  transform = 
    '_currentTime': 'eveapi.currentTime'
    '_cachedUntil': 'eveapi.cachedUntil'
    'characters':
      '$path': "eveapi.result.characters"
      "id": "characterID"
      "name": "name"
      "corp.id": "corporationID"
      "corp.name": "corporationName"
      "alliance.id": "allianceID"
      "alliance.name": "allianceName"
      "faction.id": "factionID"
      "faction.name": "factionName"
  return client.key(key).transform(transform).request()