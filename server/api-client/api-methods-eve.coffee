# Veldspar EVE Online API Client
# api-methods-char.coffee - Character related API method calls
# Copyright © Denis Luchkin-Zhou
Veldspar = (exports ? this).Veldspar
Veldspar.API ?= { }
# Account related API methods
Eve = Veldspar.API.Eve ?= { }

# Public: Gets the character information.
#
# key -     {Object} containing API Key information
#           :id -   API Key ID
#           :code - API Key Verification Code
#           :accessMask - Access mask of the API Key
#
# Returns an {Object} containing the character information.
Eve.getCharacterInfo       = (key, charID) ->
  client = new Veldspar.ApiClient '/eve/CharacterInfo.xml.aspx'
  transform =
    '_currentTime': 'date:eveapi.currentTime'
    '_cachedUntil': 'date:eveapi.cachedUntil'
    'id': 'number:eveapi.result.characterID'
    'name': 'eveapi.result.characterName'
    'race': 'eveapi.result.race'
    'bloodline': 'eveapi.result.bloodline'
    'balance': 'number:eveapi.result.accountBalance'
    'skillpoints': 'number:eveapi.result.skillPoints'
    'ship.name': 'eveapi.result.shipName'
    'ship.type.id': 'number:eveapi.result.shipTypeID'
    'ship.type.name': 'eveapi.result.shipTypeName'
    'corp.id': 'number:eveapi.result.corporationID'
    'corp.name': 'eveapi.result.corporation'
    'dorp.date': 'date:eveapi.result.corporationDate'
    'location': 'eveapi.result.lastKnownLocation'
    'securityStatus': 'number:eveapi.result.securityStatus'
    'employmentHistory':
      '$path': 'eveapi.result.employmentHistory'
      'id': 'number:recordID'
      'corp.id': 'number:corporationID'
      'date': 'date:startDate'
  return client
    .key(key)
    .permission(8388608)
    .params(characterID: charID)
    .transform(transform)
    .request()

# Public: Gets the character names.
#
# IDs - Array of character IDs
#
# Returns a hash of id-name pairs.
Eve.getCharacterName       = (IDs) ->
  client = new Veldspar.ApiClient '/eve/CharacterName.xml.aspx'
  transform =
    '_currentTime': 'date:eveapi.currentTime'
    '_cachedUntil': 'date:eveapi.cachedUntil'
    'names':
      '$path': 'eveapi.result.characters'
      'id': 'characterID'
      'name': 'name'
  raw = client
    .params(ids: IDs.join ',')
    .transform(transform)
    .request()
  return _.indexBy raw.names, 'id'
