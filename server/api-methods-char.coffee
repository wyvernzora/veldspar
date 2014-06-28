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
    '_currentTime': 'date:eveapi.currentTime'
    '_cachedUntil': 'date:eveapi.cachedUntil'
    'accounts':
      '$path': 'eveapi.result.accounts'
      'id': 'number:accountID'
      'key': 'number:accountKey'
      'balance': 'number:balance'
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
    'id': 'number:itemID'
    'location.id': 'number:locationID'
    'type.id': 'number:typeID'
    'quantity': 'number:quantity'
    'flag': 'number:flag'
    'stackable': 'booln:singleton'
    'rawQuantity': 'number:rawQuantity'
  transform =
    '_currentTime': 'date:eveapi.currentTime'
    '_cachedUntil': 'date:eveapi.cachedUntil'
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
    '_currentTime': 'date:eveapi.currentTime'
    '_cachedUntil': 'date:eveapi.cachedUntil'
    'id': 'number:eveapi.result.characterID'
    'name': 'eveapi.result.name'
    'dob': 'date:eveapi.result.DoB'
    'race': 'eveapi.result.race'
    'bloodLine': 'eveapi.result.bloodLine'
    'ancestry': 'eveapi.result.ancestry'
    'gender': 'eveapi.result.gender'
    'balance': 'number:eveapi.result.balance'
    'corp.id': 'number:eveapi.result.corporationID'
    'corp.name': 'eveapi.result.corporationName'
    'alliance.id': 'number:eveapi.result.allianceID'
    'alliance.name': 'eveapi.result.allianceName'
    'faction.id': 'number:eveapi.result.factionID'
    'faction.name': 'eveapi.result.factionName'
    'clone.name': 'eveapi.result.cloneName'
    'clone.skillPoints': 'number:eveapi.result.cloneSkillPoints'
    'attributes.memory.value': 'number:eveapi.result.attributes.memory'
    'attributes.memory.implant': 'eveapi.result.attributeEnhancers.memoryBonus.augmentatorName'
    'attributes.memory.bonus': 'number:eveapi.result.attributeEnhancers.memoryBonus.augmentatorValue'
    'attributes.willpower.value': 'number:eveapi.result.attributes.willpower'
    'attributes.willpower.implant': 'eveapi.result.attributeEnhancers.willpowerBonus.augmentatorName'
    'attributes.willpower.bonus': 'number:eveapi.result.attributeEnhancers.willpowerBonus.augmentatorValue'
    'attributes.perception.value': 'number:eveapi.result.attributes.perception'
    'attributes.perception.implant': 'eveapi.result.attributeEnhancers.perceptionBonus.augmentatorName'
    'attributes.perception.bonus': 'number:eveapi.result.attributeEnhancers.perceptionBonus.augmentatorValue'
    'attributes.charisma.value': 'number:eveapi.result.attributes.charisma'
    'attributes.charisma.implant': 'eveapi.result.attributeEnhancers.charismaBonus.augmentatorName'
    'attributes.charisma.bonus': 'number:eveapi.result.attributeEnhancers.charismaBonus.augmentatorValue'
    'attributes.intelligence.value': 'number:eveapi.result.attributes.intelligence'
    'attributes.intelligence.implant': 'eveapi.result.attributeEnhancers.intelligenceBonus.augmentatorName'
    'attributes.intelligence.bonus': 'number:eveapi.result.attributeEnhancers.intelligenceBonus.augmentatorValue'
    'skills': 
      '$path': 'eveapi.result.skills'
      'id': 'number:typeID'
      'sp': 'number:skillpoints'
      'level': 'number:level'
      'published': 'bool:published'
    'corporationRoles.generic': 
      '$path': 'eveapi.result.corporationRoles'
      'id': 'number:roleID'
      'name': 'roleName'
    'corporationRoles.atHQ': 
      '$path': 'eveapi.result.corporationRolesAtHQ'
      'id': 'number:roleID'
      'name': 'roleName'
    'corporationRoles.atBase': 
      '$path': 'eveapi.result.corporationRolesAtBase'
      'id': 'number:roleID'
      'name': 'roleName'
    'corporationRoles.atOther': 
      '$path': 'eveapi.result.corporationRolesAtOther'
      'id': 'number:roleID'
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
    '_currentTime': 'date:eveapi.currentTime'
    '_cachedUntil': 'date:eveapi.cachedUntil'
    'contacts.character': 
      '$path': 'eveapi.result.contactList'
      'id': 'number:contactID'
      'name': 'contactName'
      'standing': 'number:standing'
      'typeID': 'number:contactTypeID'
    'contacts.corporation': 
      '$path': 'eveapi.result.corporateContactList'
      'id': 'number;contactID'
      'name': 'contactName'
      'standing': 'number:standing'
      'typeID': 'number:contactTypeID'
    'contacts.alliance': 
      '$path': 'eveapi.result.allianceContactList'
      'id': 'number:contactID'
      'name': 'contactName'
      'standing': 'number:standing'
      'typeID': 'number:contactTypeID'
  return client
    .key(key)
    .permission(16)
    .params(characterID: charID)
    .transform(transform)
    .request()

Character.getContactNotifications = (key, charID) ->
  client = new Veldspar.ApiClient '/char/ContactNotifications.xml.aspx'
  transform = 
    '_currentTime': 'date:eveapi.currentTime'
    '_cachedUntil': 'date:eveapi.cachedUntil'
    'notifications':
      '$path': 'eveapi.result.contactNotifications'
      'id': 'number:notificationID'
      'sender.id': 'number:senderID'
      'sender.name': 'senderName'
      'sentDate': 'date:sentDate'
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
    n.level = Number(n.level) if n.level
  return raw
  
Character.getContracts = (key, charID, contractID) ->
  client = new Veldspar.ApiClient '/char/Contracts.xml.aspx'
  transform =
    '_currentTime': 'date:eveapi.currentTime'
    '_cachedUntil': 'date:eveapi.cachedUntil'
    'contracts': 
      '$path': 'eveapi.result.contractList'
      'id': 'number:contractID'
      'type': 'type'
      'status': 'status'
      'title': 'title'
      'forCorp': 'bool:forCorp'
      'availability': 'availability'
      'issuer.id': 'number:issuerID'
      'issuerCorp.id': 'number:issuerCorpID'
      'assignee.id': 'number:assigneeID'
      'acceptop.id': 'number:acceptorID'
      'startStation.id': 'number:startStationID'
      'endStation.id': 'number:endStationID'
      'dates.issued': 'date:dateIssued'
      'dates.expired': 'date:dateExpired'
      'dates.accepted': 'date:dateAccepted'
      'dates.completed': 'date:dateCompleted'
      'numDays': 'number:numDays'
      'price': 'number:price'
      'reward': 'number:reward'
      'collateral': 'number:collateral'
      'buyout': 'number:buyout'
      'volume': 'number:volume'
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
    '_currentTime': 'date:eveapi.currentTime'
    '_cachedUntil': 'date:eveapi.cachedUntil'
    'items':
      '$path': 'eveapi.result.itemList'
      'id': 'number:recordID'
      'type.id': 'number:typeID'
      'quantity': 'number:quantity'
      'rawQuantity': 'number:rawQuantity'
      'stackable': 'booln:singleton'
      'included': 'bool:included'
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
    '_currentTime': 'date:eveapi.currentTime'
    '_cachedUntil': 'date:eveapi.cachedUntil'
    'bids':
      '$path': 'eveapi.result.bidList'
      'id': 'number:bidID'
      'contract.id': 'number:contractID'
      'bidder.id': 'number:bidderID'
      'date': 'date:dateBid'
      'amount': 'number:amount'
  return client
    .key(key)
    .permission(67108864)
    .params('characterID': charID, 'contractID': contractID)
    .transform(transform)
    .request()
  
Character.getFacWarStats = (key, charID) ->
  client = new Veldspar.ApiClient '/char/FacWarStats.xml.aspx'
  transform =
    '_currentTime': 'date:eveapi.currentTime'
    '_cachedUntil': 'date:eveapi.cachedUntil'
    'faction.id': 'number:eveapi.result.factionID'
    'faction.name': 'eveapi.result.factionName'
    'enlisted': 'date:eveapi.result.enlisted'
    'currentRank': 'number:eveapi.result.currentRank'
    'highestRank': 'number:eveapi.result.highestRank'
    'kills.yesterday': 'number:eveapi.result.killsYesterday'
    'kills.lastWeek': 'number:eveapi.result.killsLastWeek'
    'kills.total': 'number:eveapi.result.killsTotal'
    'victoryPoints.yesterday': 'number:eveapi.result.victoryPointsYesterday'
    'victoryPoints.lastWeek': 'number:eveapi.result.victoryPointsLastWeek'
    'victoryPoints.total': 'number:eveapi.result.victoryPointsTotal'
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
    '_currentTime': 'date:eveapi.currentTime'
    '_cachedUntil': 'date:eveapi.cachedUntil'
    'kills':
      '$path': 'eveapi.result.kills'
      'id': 'number:killID'
      'solarSystem.id': 'number:solarSystemID'
      'time': 'date:killTime'
      'moon.id': 'number:moonID'
      'victim.id': 'number:victim.characterID'
      'victim.name': 'victim.characterName'
      'victim.corp.id': 'number:victim.corporationID'
      'victim.corp.name': 'victim.corporationName'
      'victim.faction.id': 'number:victim.factionID'
      'victim.faction.name': 'victim.factionName'
      'victim.alliance.id': 'number:victim.allianceID'
      'victim.alliance.name': 'victim.allianceName'
      'victim.shipType.id': 'number:victim.shipTypeID'
      'victim.damageTaken': 'number:victim.damageTaken'
      'attackers':
        '$path': 'attackers'
        'id': 'number:characterID'
        'name': 'characterName'
        'corp.id': 'number:corporationID'
        'corp.name': 'corporationName'
        'alliance.id': 'number:allianceID'
        'alliance.name': 'allianceName'
        'faction.id': 'number:factionID'
        'faction.name': 'factionName'
        'damageDone': 'number:damageDone'
        'finalBlow': 'bool:finalBlow'
        'securityStatus': 'number:securityStatus'
        'shipType.id': 'number:shipTypeID'
        'weaponType.id': 'number:weaponTypeID'
      'items':
        '$path': 'items'
        'flag': 'number:flag'
        'qtyDropped': 'number:qtyDropped'
        'qtyDestroyed': 'number:qtyDestroyed'
        'type.id': 'number:typeID'
        'singleton': 'number:singleton'
  return client
    .key(key)
    .permission(256)
    .params('characterID': charID, 'beforeKillID': beforeKillID)
    .transform(transform)
    .request()
    
Character.getLocations = (key, charID, IDs) ->
  client = new Veldspar.ApiClient '/char/Locations.xml.aspx'
  transform =
    '_currentTime': 'date:eveapi.currentTime'
    '_cachedUntil': 'date:eveapi.cachedUntil'
    'locations':
      '$path': 'eveapi.result.locations'
      'item.id': 'number:itemID'
      'item.name': 'itemName'
      'x': 'number:x'
      'y': 'number:y'
      'z': 'number:z'
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
    '_currentTime': 'date:eveapi.currentTime'
    '_cachedUntil': 'date:eveapi.cachedUntil'
    'messages':
      '$path': 'eveapi.result.messages'
      'id': 'number:messageID'
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
Character.getMailingLists = (key, charID) ->
  client = new Veldspar.ApiClient '/char/MailingLists.xml.aspx'
  transform =
    '_currentTime': 'date:eveapi.currentTime'
    '_cachedUntil': 'date:eveapi.cachedUntil'
    'mailingLists':
      '$path': 'eveapi.result.mailingLists'
      'id': 'number:listID'
      'name': 'displayName'
  return client
    .key(key)
    .permission(1024)
    .params('characterID': charID)
    .transform(transform)
    .request()

Character.getMailHeaders = (keyy, charID) ->
  client = new Veldspar.ApiClient '/char/MailMessages.xml.aspx'
  transform =
    '_currentTime': 'date:eveapi.currentTime'
    '_cachedUntil': 'date:eveapi.cachedUntil'
    'messages':
      '$path': 'eveapi.result.messages'
      'id': 'number:messageID'
      'sender.id': 'number:senderID'
      'sender.name': 'senderName'
      'date': 'date:sentDate'
      'title': 'title'
      # TODO Implement a better receiver parsing logic
  throw new Meteor.Error 0, 'API method not implemented.'

      