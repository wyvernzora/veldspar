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
    "_currentTime": "date:eveapi.currentTime"
    "_cachedUntil": "date:eveapi.cachedUntil"
    "type": "eveapi.result.key.type"
    "accessMask": "number:eveapi.result.key.accessMask"
    "expires": "date:eveapi.result.key.expires"
    "characters":
      "$path": "eveapi.result.key.characters"
      "id": "number:characterID"
      "name": "characterName"
      "corp.id": "number:corporationID"
      "corp.name": "corporationName"
      "alliance.id": "number:allianceID"
      "alliance.name": "allianceName"
      "faction.id": "number:factionID"
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
    '_currentTime': 'date:eveapi.currentTime'
    '_cachedUntil': 'date:eveapi.cachedUntil'
    'paidUntil': 'date:eveapi.result.paidUntil'
    'createDate': 'date:eveapi.result.createDate'
    'logonCount': 'number:eveapi.result.logonCount'
    'logonMinutes': 'number:eveapi.result.logonMinutes'
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
    '_currentTime': 'date:eveapi.currentTime'
    '_cachedUntil': 'date:eveapi.cachedUntil'
    'characters':
      '$path': "eveapi.result.characters"
      "id": "number:characterID"
      "name": "name"
      "corp.id": "number:corporationID"
      "corp.name": "corporationName"
      "alliance.id": "number:allianceID"
      "alliance.name": "allianceName"
      "faction.id": "number:factionID"
      "faction.name": "factionName"
  return client.key(key).transform(transform).request()