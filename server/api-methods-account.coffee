# Veldspar EVE Online API Client
# api-methods-account.coffee - Account related API method calls
# Copyright © Denis Luchkin-Zhou
Veldspar = (exports ? this).Veldspar
Veldspar.API ?= { }

# Account related API methods
Account = Veldspar.API.Account ?= { }

Account.getApiKeyInfo = (key) ->
  client = new Veldspar.ApiClient('/account/APIKeyInfo.xml.aspx')
  transform = 
    "_currentTime": "eveapi.currentTime",
    "_cachedUntil": "eveapi.cachedUntil",
    "type": "eveapi.result.key.type",
    "accessMask": "eveapi.result.key.accessMask",
    "expires": "eveapi.result.key.expires",
    "characters":
      "_path_": "eveapi.result.key.characters",
      "id": "characterID",
      "name": "characterName",
      "corp.id": "corporationID",
      "corp.name": "corporationName",
      "alliance.id": "allianceID",
      "alliance.name": "allianceName",
      "faction.id": "factionID",
      "faction.name": "factionName"
  return client.key(key).transform(transform).request()

Account.getPermissionReference = (key) ->
  client = new Veldspar.ApiClient('/api/calllist.xml.aspx')
  transform =
    'groups':
      '_path_': 'eveapi.result.callGroups',
      'id': 'id',
      'name': 'name',
      'description': 'description',
    'calls':
      '_path_': 'eveapi.result.calls',
      'name': 'name',
      'description': 'description',
      'mask': 'accessMask',
      'group': 'groupID'
      
  return client.key(key).transform(transform).request()
