# Veldspar EVE Online API Client
# api-methods-char.coffee - Character related API method calls
# Copyright © Denis Luchkin-Zhou
Veldspar = (exports ? this).Veldspar
Veldspar.API ?= { }
# Account related API methods
Character = Veldspar.API.Character ?= { }
# Public: Gets the remaining ISK balance of the character's accounts.
#
# key -     {Object} containing API Key information
#           :id -   API Key ID
#           :code - API Key Verification Code
#           :accessMask - Access mask of the API Key
#
# Returns an {Object} containing the account balance.
Character.getAccountBalance = (key, charID) ->
  client = new Veldspar.ApiClient '/char/AccountBalance.xml.aspx'
  transform =
    '_currentTime': 'eveapi.currentTime'
    '_cachedUntil': 'eveapi.cachedUntil'
    'accounts':
      '$path': 'eveapi.result.accounts'
      'id': 'accountID'
      'key': 'accountKey'
      'balance': 'balance'
  return client
    .key(key)
    .permission(1)
    .params(characterID: charID)
    .transform(transform)
    .request()
# Public: Gets the complete list of assets of a character.
# This includes contents of containers as deeply nested as needed.
#
# key -     {Object} containing API Key information
#           :id -   API Key ID
#           :code - API Key Verification Code
#           :accessMask - Access mask of the API Key
#
# Returns an {Object} containing the asset list.
Character.getAssetList = (key, charID) ->
  client = new Veldspar.ApiClient '/char/AssetList.xml.aspx'
  assetTransformRec =
    '$path': 'contents'
    'id': 'itemID'
    'location.id': 'locationID'
    'type.id': 'typeID'
    'quantity': 'quantity'
    'flag': 'flag'
    'stackable': (o) ->
      singleton = Veldspar.Transformer.property o, 'singleton'
      return not singleton
    'rawQuantity': 'rawQuantity'
  transform =
    '_currentTime': 'eveapi.currentTime'
    '_cachedUntil': 'eveapi.cachedUntil'
  # Make the transform recursive
  assetTransform = _.clone assetTransformRec
  assetTransformRec.contents = assetTransformRec
  assetTransform.$path = 'eveapi.result.assets'
  assetTransform.contents = assetTransformRec
  transform.assets = assetTransform
  # Call API
  return client
    .key(key)
    .permission(2)
    .params(characterID: charID)
    .transform(transform)
    .request()
# Public: Gets the information about the chatacter, specifically skills,
# attributes and such.
#
# key -     {Object} containing API Key information
#           :id -   API Key ID
#           :code - API Key Verification Code
#           :accessMask - Access mask of the API Key
#
# Returns an {Object} containing the information about the character.

# TODO /char/CalendarEventAttendees #

Character.getCharacterSheet = (key, charID) ->
  client = new Veldspar.ApiClient '/char/CharacterSheet.xml.aspx'
  transform =
    '_currentTime': 'eveapi.currentTime'
    '_cachedUntil': 'eveapi.cachedUntil'
    'id': 'eveapi.result.characterID'
    'name': 'eveapi.result.name'
    'dob': 'eveapi.result.DoB'
    'race': 'eveapi.result.race'
    'bloodLine': 'eveapi.result.bloodLine'
    'ancestry': 'eveapi.result.ancestry'
    'gender': 'eveapi.result.gender'
    'balance': 'eveapi.result.balance'
    'corp.id': 'eveapi.result.corporationID'
    'corp.name': 'eveapi.result.corporationName'
    'alliance.id': 'eveapi.result.allianceID'
    'alliance.name': 'eveapi.result.allianceName'
    'faction.id': 'eveapi.result.factionID'
    'faction.name': 'eveapi.result.factionName'
    'clone.name': 'eveapi.result.cloneName'
    'clone.skillPoints': 'eveapi.result.cloneSkillPoints'
    'attributes.memory.value': 'eveapi.result.attributes.memory'
    'attributes.memory.implant': 'eveapi.result.attributeEnhancers.memoryBonus.augmentatorName'
    'attributes.memory.bonus': 'eveapi.result.attributeEnhancers.memoryBonus.augmentatorValue'
    'attributes.willpower.value': 'eveapi.result.attributes.willpower'
    'attributes.willpower.implant': 'eveapi.result.attributeEnhancers.willpowerBonus.augmentatorName'
    'attributes.willpower.bonus': 'eveapi.result.attributeEnhancers.willpowerBonus.augmentatorValue'
    'attributes.perception.value': 'eveapi.result.attributes.perception'
    'attributes.perception.implant': 'eveapi.result.attributeEnhancers.perceptionBonus.augmentatorName'
    'attributes.perception.bonus': 'eveapi.result.attributeEnhancers.perceptionBonus.augmentatorValue'
    'attributes.charisma.value': 'eveapi.result.attributes.charisma'
    'attributes.charisma.implant': 'eveapi.result.attributeEnhancers.charismaBonus.augmentatorName'
    'attributes.charisma.bonus': 'eveapi.result.attributeEnhancers.charismaBonus.augmentatorValue'
    'attributes.intelligence.value': 'eveapi.result.attributes.intelligence'
    'attributes.intelligence.implant': 'eveapi.result.attributeEnhancers.intelligenceBonus.augmentatorName'
    'attributes.intelligence.bonus': 'eveapi.result.attributeEnhancers.intelligenceBonus.augmentatorValue'
    'skills': 
      '$path': 'eveapi.result.skills'
      'id': 'typeID'
      'sp': 'skillpoints'
      'level': 'level'
      'published': (o) ->
        value = Veldspar.Transformer.property o, 'published';
        return value and true;
    'corporationRoles.generic': 
      '$path': 'eveapi.result.corporationRoles'
      'id': 'roleID'
      'name': 'roleName'
    'corporationRoles.atHQ': 
      '$path': 'eveapi.result.corporationRolesAtHQ'
      'id': 'roleID'
      'name': 'roleName'
    'corporationRoles.atBase': 
      '$path': 'eveapi.result.corporationRolesAtBase'
      'id': 'roleID'
      'name': 'roleName'
    'corporationRoles.atOther': 
      '$path': 'eveapi.result.corporationRolesAtOther'
      'id': 'roleID'
      'name': 'roleName'
    'corporationTitles': 
      '$path': 'eveapi.result.corporationTitles'
  return client
    .key(key)
    .permission(8)
    .params(characterID: charID)
    .transform(transform)
    .request()

Character.getContactList = (key, charID) ->
  client = new Veldspar.ApiClient '/char/ContactList.xml.aspx'
  transform =
    '_currentTime': 'eveapi.currentTime'
    '_cachedUntil': 'eveapi.cachedUntil'
    'contacts.character': 
      '$path': 'eveapi.result.contactList'
      'id': 'contactID'
      'name': 'contactName'
      'standing': 'standing'
      'typeID': 'contactTypeID'
    'contacts.corporation': 
      '$path': 'eveapi.result.corporateContactList'
      'id': 'contactID'
      'name': 'contactName'
      'standing': 'standing'
      'typeID': 'contactTypeID'
    'contacts.alliance': 
      '$path': 'eveapi.result.allianceContactList'
      'id': 'contactID'
      'name': 'contactName'
      'standing': 'standing'
      'typeID': 'contactTypeID'
  return client
    .key(key)
    .permission(16)
    .params(characterID: charID)
    .transform(transform)
    .request()

Character.getContactNotifications = (key, charID) ->
  client = new Veldspar.ApiClient '/char/ContactNotifications.xml.aspx'
  transform = 
    '_currentTime': 'eveapi.currentTime'
    '_cachedUntil': 'eveapi.cachedUntil'
    'notifications':
      '$path': 'eveapi.result.contactNotifications'
      'id': 'notificationID'
      'sender.id': 'senderID'
      'sender.name': 'senderName'
      'sentDate': 'sentDate'
      'data': 'messageData'
  raw = client
    .key(key)
    .permission(32)
    .params(characterID: charID)
    .transform(transform)
    .request()
  # Need post-processing to parse the data field
  _.each raw.notifications, (n) ->
    _.reduce _.map(n.data.split('\n'), (i) -> i.split ':'), (mem, i) ->
      mem[i[0]] = i[1]
      return mem
    , n
    n.data = undefined
  return raw
  
Character.getContracts = (key, charID, contractID) ->
  client = new Veldspar.ApiClient '/char/Contracts.xml.aspx'
  transform =
    '_currentTime': 'eveapi.currentTime'
    '_cachedUntil': 'eveapi.cachedUntil'
    'contracts': 
      '$path': 'eveapi.result.contractList'
      'id': 'contractID'
      'type': 'type'
      'status': 'status'
      'title': 'title'
      'forCorp': (o) ->
        flag = Veldspar.Transformer.property o, 'forCorp'
        return flag && true
      'availability': 'availability'
      'issuer.id': 'issuerID'
      'issuerCorp.id': 'issuerCorpID'
      'assignee.id': 'assigneeID'
      'acceptop.id': 'acceptorID'
      'startStation.id': 'startStationID'
      'endStation.id': 'endStationID'
      'dates.issued': 'dateIssued'
      'dates.expired': 'dateExpired'
      'dates.accepted': 'dateAccepted'
      'dates.completed': 'dateCompleted'
      'numDays': 'numDays'
      'price': 'price'
      'reward': 'reward'
      'collateral': 'collateral'
      'buyout': 'buyout'
      'volume': 'volume'
  return client
    .key(key)
    .permission(67108864)
    .params('characterID': charID, 'contractID': contractID)
    .transform(transform)
    .request()

Character.getContractItems = (key, charID, contractID) ->
  if _.isUndefined contractID
    throw new Meteor.Error 15, 'Method requires contractID, which is undefined.'
  client = new Veldspar.ApiClient '/char/ContractItems.xml.aspx'
  transform =
    '_currentTime': 'eveapi.currentTime'
    '_cachedUntil': 'eveapi.cachedUntil'
    'items':
      '$path': 'eveapi.result.itemList'
      'id': 'recordID'
      'type.id': 'typeID'
      'quantity': 'quantity'
      'rawQuantity': 'rawQuantity'
      'stackable': (o) ->
        v = Veldspar.Transformer.property o, 'singleton'
        console.log typeof v
        return Number(v) is 0
      'included': (o) ->
        v = Veldspar.Transformer.property o, 'included'
        return Number(v) is 1
  return client
    .key(key)
    .permission(67108864)
    .params('characterID': charID, 'contractID': contractID)
    .transform(transform)
    .request()

Character.getContractBids = (key, charID, contractID) ->
  if _.isUndefined contractID
    throw new Meteor.Error 15, 'Method requires contractID, which is undefined.'
  client = new Veldspar.ApiClient '/char/ContractBids.xml.aspx'
  transform =
    '_currentTime': 'eveapi.currentTime'
    '_cachedUntil': 'eveapi.cachedUntil'
    'bids':
      '$path': 'eveapi.result.bidList'
      'id': 'bidID'
      'contract.id': 'contractID'
      'bidder.id': 'bidderID'
      'date': 'dateBid'
      'amount': 'amount'
  return client
    .key(key)
    .permission(67108864)
    .params('characterID': charID, 'contractID': contractID)
    .transform(transform)
    .request()
  
Character.getFacWarStats = (key, charID) ->
  client = new Veldspar.ApiClient '/char/FacWarStats.xml.aspx'
  transform =
    '_currentTime': 'eveapi.currentTime'
    '_cachedUntil': 'eveapi.cachedUntil'
    'faction.id': 'eveapi.result.factionID'
    'faction.name': 'eveapi.result.factionName'
    'enlisted': 'eveapi.result.enlisted'
    'currentRank': 'eveapi.result.currentRank'
    'highestRank': 'eveapi.result.highestRank'
    'kills.yesterday': 'eveapi.result.killsYesterday'
    'kills.lastWeek': 'eveapi.result.killsLastWeek'
    'kills.total': 'eveapi.result.killsTotal'
    'victoryPoints.yesterday': 'eveapi.result.victoryPointsYesterday'
    'victoryPoints.lastWeek': 'eveapi.result.victoryPointsLastWeek'
    'victoryPoints.total': 'eveapi.result.victoryPointsTotal'
  return client
    .key(key)
    .permission(64)
    .params('characterID': charID)
    .transform(transform, no) # No need to unwrap
    .request()
    
Character.getIndustryJobs = (key, charID) ->
  throw new Meteor.Error 0, 'Method call not implemented.'

Character.getKillLog = (key, charID, beforeKillID) ->
  client = new Veldspar.ApiClient '/char/KillLog.xml.aspx'
  transform =
    '_currentTime': 'eveapi.currentTime'
    '_cachedUntil': 'eveapi.cachedUntil'
    'kills':
      '$path': 'eveapi.result.kills'
      'id': 'killID'
      'solarSystem.id': 'solarSystemID'
      'time': 'killTime'
      'moon.id': 'moonID'
      'victim.id': 'victim.characterID'
      'victim.name': 'victim.characterName'
      'victim.corp.id': 'victim.corporationID'
      'victim.corp.name': 'victim.corporationName'
      'victim.faction.id': 'victim.factionID'
      'victim.faction.name': 'victim.factionName'
      'victim.alliance.id': 'victim.allianceID'
      'victim.alliance.name': 'victim.allianceName'
      'victim.shipType.id': 'victim.shipTypeID'
      'victim.damageTaken': 'victim.damageTaken'
      'attackers':
        '$path': 'attackers'
        'id': 'characterID'
        'name': 'characterName'
        'corp.id': 'corporationID'
        'corp.name': 'corporationName'
        'alliance.id': 'allianceID'
        'alliance.name': 'allianceName'
        'faction.id': 'factionID'
        'faction.name': 'factionName'
        'damageDone': 'damageDone'
        'finalBlow': (o) ->
          v = Veldspar.Transformer.property o, 'finalBlow'
          return v is '1'
        'securityStatus': 'securityStatus'
        'shipType.id': 'shipTypeID'
        'weaponType.id': 'weaponTypeID'
      'items':
        '$path': 'items'
        'flag': 'flag'
        'qtyDropped': 'qtyDropped'
        'qtyDestroyed': 'qtyDestroyed'
        'type.id': 'typeID'
        'singleton': 'singleton'
  return client
    .key(key)
    .permission(256)
    .params('characterID': charID, 'beforeKillID': beforeKillID)
    .transform(transform)
    .request()
    
Character.getLocations = (key, charID, IDs) ->
  client = new Veldspar.ApiClient '/char/Locations.xml.aspx'
  transform =
    '_currentTime': 'eveapi.currentTime'
    '_cachedUntil': 'eveapi.cachedUntil'
    'locations':
      '$path': 'eveapi.result.locations'
      'item.id': 'itemID'
      'item.name': 'itemName'
      'x': 'x'
      'y': 'y'
      'z': 'z'
  strIds = IDs.join ',' if not _.isUndefined IDs
  return client
    .key(key)
    .permission(134217728)
    .params('characterID': charID, 'IDs': strIds)
    .transform(transform)
    .request()

Character.getMailBodies = (key, charID, IDs) ->
  client = new Veldspar.ApiClient '/char/MailBodies.xml.aspx'
  transform = 
    '_currentTime': 'eveapi.currentTime'
    '_cachedUntil': 'eveapi.cachedUntil'
    'messages':
      '$path': 'eveapi.result.messages'
      'id': 'messageID'
      'data': '_'
    'missing': (o) ->
      v = Veldspar.Transformer.property o, 'eveapi.result.missingMessageIDs'
      return _.map v.split(','), (i) -> Number(i)
  strIds = IDs.join ',' if not _.isUndefined IDs
  return client
    .key(key)
    .permission(512)
    .params('characterID': charID, 'IDs': strIds)
    .transform(transform)
    .request()