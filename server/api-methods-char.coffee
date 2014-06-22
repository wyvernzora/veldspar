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
    'locationID': 'locationID'
    'typeID': 'typeID'
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
      'skillPoints': 'skillpoints'
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
  throw new Meteor.Error 0, 'Method not implemented'
    
    