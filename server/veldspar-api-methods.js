/* API method calls */
Veldspar.API.AccountInfo = {

  getApiKeyInfo: function (apiKey) {
    "use strict";
    var client = new Veldspar.API.Client("/account/APIKeyInfo.xml.aspx"),
      transform = {
        "_currentTime": "eveapi.currentTime",
        "_cachedUntil": "eveapi.cachedUntil",
        "type": "eveapi.result.key.type",
        "accessMask": "eveapi.result.key.accessMask",
        "expires": "eveapi.result.key.expires",
        "characters": {
          "_path_": "eveapi.result.key.characters",
          "id": "characterID",
          "name": "characterName",
          "corp.id": "corporationID",
          "corp.name": "corporationName",
          "alliance.id": "allianceID",
          "alliance.name": "allianceName",
          "faction.id": "factionID",
          "faction.name": "factionName"
        }
      };
    return client
      .setApiKey(apiKey)
      .setTransform(transform, true)
      .request();
  },

  getAccountStatus: function (apiKey) {
    "use strict";
    var client = new Veldspar.API.Client("/account/AccountStatus.xml.aspx"),
      transform = {
        "_currentTime": "eveapi.currentTime",
        "_cachedUntil": "eveapi.cachedUntil",
        "paidUntil": "eveapi.result.paidUntil",
        "createDate": "eveapi.result.createDate",
        "logonCount": "eveapi.result.logonCount",
        "logonMinutes": "eveapi.result.logonMinutes"
      };
    return client
      .setApiKey(apiKey)
      .requireAccessMask(33554432)
      .setTransform(transform, true)
      .request();
  },

  getAccountCharacters: function (apiKey) {
    "use strict";
    var client = new Veldspar.API.Client("/account/Characters.xml.aspx"),
      transform = {
        "_currentTime": "eveapi.currentTime",
        "_cachedUntil": "eveapi.cachedUntil",
        "characters": {
          "_path_": "eveapi.result.characters",
          "id": "characterID",
          "name": "characterName",
          "corp.id": "corporationID",
          "corp.name": "corporationName",
          "alliance.id": "allianceID",
          "alliance.name": "allianceName",
          "faction.id": "factionID",
          "faction.name": "factionName"
        }
      };

    return client
      .setApiKey(apiKey)
      .setTransform(transform, true)
      .request();
  }

};

Veldspar.API.Character = {

  getAccountBalance: function (apiKey, characterID) {
    "use strict";
    var client = new Veldspar.API.Client("/char/AccountBalance.xml.aspx"),
      transform = {
        "_currentTime": "eveapi.currentTime",
        "_cachedUntil": "eveapi.cachedUntil",
        "accounts": {
          "_path_": "eveapi.result.accounts",
          "id": "accountID",
          "key": "accountKey",
          "balance": "balance"
        }
      };
    return client
      .setApiKey(apiKey)
      .requireAccessMask(1)
      .addParams({
        characterID: characterID
      })
      .setTransform(transform, true)
      .request();
  },

  getAssetList: function (apiKey, characterID) {
    "use strict";
    /*
     Asset list returned by CCP may be recursive, therefore defining the
     transformation rules may be a bit tricky too.
     assetTransform variable is for the first-level asset entries, while
     the recAssetTransform is for 'nested' assets contained in parent
     asset entries.
     Therefore the 'nested' asset transformations need diferent '_path_'
     variables and both transforms can only be recursively assigned after
     variable initialization is complete (after the var statement).
    */
    var client = new Veldspar.API.Client("/char/AssetList.xml.aspx"),
      recAssetTransform = {
        "_path_": "contents",
        "id": "itemID",
        "locationID": "locationID",
        "typeID": "typeID",
        "quantity": "quantity",
        "flag": "flag",
        "stackable": function (o) {
          var singleton = Transformer.getProperty(o, "singleton");
          return !singleton;
        },
        "rawQuantity": "rawQuantity"
      },
      transform = {
        "_currentTime": "eveapi.currentTime",
        "_cachedUntil": "eveapi.cachedUntil"
      },
      assetTransform = _.clone(recAssetTransform);
    /* Making the transform recursive */
    recAssetTransform.contents = recAssetTransform;
    assetTransform._path_ = "eveapi.result.assets";
    assetTransform.contents = recAssetTransform;
    transform.assets = assetTransform;

    return client
      .setApiKey(apiKey)
      .requireAccessMask(2)
      .addParams({
        characterID: characterID
      })
      .setTransform(transform, true)
      .request();
  },

  getCalendarEventAttendees: function (apiKey, characterID, eventID) {
    "use strict";
    /* Not Implemented */
    throw new Meteor.Error(0, "Feature not implemented.");
  },

  getCharacterSheet: function (apiKey, characterID) {
    "use strict";
    var client = new Veldspar.API.Client("/char/CharacterSheet.xml.aspx"),
      transform = {
        "_currentTime": "eveapi.currentTime",
        "_cachedUntil": "eveapi.cachedUntil",
        "id": "eveapi.result.characterID",
        "name": "eveapi.result.name",
        "dob": "eveapi.result.DoB",
        "race": "eveapi.result.race",
        "bloodLine": "eveapi.result.bloodLine",
        "ancestry": "eveapi.result.ancestry",
        "gender": "eveapi.result.gender",
        "balance": "eveapi.result.balance",
        "corp.id": "eveapi.result.corporationID",
        "corp.name": "eveapi.result.corporationName",
        "alliance.id": "eveapi.result.allianceID",
        "alliance.name": "eveapi.result.allianceName",
        "faction.id": "eveapi.result.factionID",
        "faction.name": "eveapi.result.factionName",
        "clone.name": "eveapi.result.cloneName",
        "clone.skillPoints": "eveapi.result.cloneSkillPoints",
        "attributes.memory.value": "eveapi.result.attributes.memory",
        "attributes.memory.implant": "eveapi.result.attributeEnhancers.memoryBonus.augmentatorName",
        "attributes.memory.bonus": "eveapi.result.attributeEnhancers.memoryBonus.augmentatorValue",
        "attributes.willpower.value": "eveapi.result.attributes.willpower",
        "attributes.willpower.implant": "eveapi.result.attributeEnhancers.willpowerBonus.augmentatorName",
        "attributes.willpower.bonus": "eveapi.result.attributeEnhancers.willpowerBonus.augmentatorValue",
        "attributes.perception.value": "eveapi.result.attributes.perception",
        "attributes.perception.implant": "eveapi.result.attributeEnhancers.perceptionBonus.augmentatorName",
        "attributes.perception.bonus": "eveapi.result.attributeEnhancers.perceptionBonus.augmentatorValue",
        "attributes.charisma.value": "eveapi.result.attributes.charisma",
        "attributes.charisma.implant": "eveapi.result.attributeEnhancers.charismaBonus.augmentatorName",
        "attributes.charisma.bonus": "eveapi.result.attributeEnhancers.charismaBonus.augmentatorValue",
        "attributes.intelligence.value": "eveapi.result.attributes.intelligence",
        "attributes.intelligence.implant": "eveapi.result.attributeEnhancers.intelligenceBonus.augmentatorName",
        "attributes.intelligence.bonus": "eveapi.result.attributeEnhancers.intelligenceBonus.augmentatorValue",
        "skills": {
          "_path_": "eveapi.result.skills",
          "id": "typeID",
          "skillPoints": "skillpoints",
          "level": "level",
          "published": function (o) {
            var value = Transformer.getProperty(o, "published");
            return !!value;
          }
        },
        "corporationRoles.generic": {
          "_path_": "eveapi.result.corporationRoles",
          "id": "roleID",
          "name": "roleName"
        },
        "corporationRoles.atHQ": {
          "_path_": "eveapi.result.corporationRolesAtHQ",
          "id": "roleID",
          "name": "roleName"
        },
        "corporationRoles.atBase": {
          "_path_": "eveapi.result.corporationRolesAtBase",
          "id": "roleID",
          "name": "roleName"
        },
        "corporationRoles.atOther": {
          "_path_": "eveapi.result.corporationRolesAtOther",
          "id": "roleID",
          "name": "roleName"
        },
        "corporationTitles": {
          "_path_": "eveapi.result.corporationTitles"

        }
      };
    return client
      .setApiKey(apiKey)
      .requireAccessMask(8)
      .addParams({
        characterID: characterID
      })
      .setTransform(transform, true)
      .request();
  },

  getContactList: function (apiKey, characterID) {
    "use strict";
    var client = new Veldspar.API.Client("/char/ContactList.xml.aspx"),
      transform = {
        "_currentTime": "eveapi.currentTime",
        "_cachedUntil": "eveapi.cachedUntil",
        "contacts.character": {
          "_path_": "eveapi.result.contactList",
          "id": "contactID",
          "name": "contactName",
          "standing": "standing",
          "typeID": "contactTypeID"
        },
        "contacts.corporation": {
          "_path_": "eveapi.result.corporateContactList",
          "id": "contactID",
          "name": "contactName",
          "standing": "standing",
          "typeID": "contactTypeID"
        },
        "contacts.alliance": {
          "_path_": "eveapi.result.allianceContactList",
          "id": "contactID",
          "name": "contactName",
          "standing": "standing",
          "typeID": "contactTypeID"
        }
      };
    return client
      .setApiKey(apiKey)
      .requireAccessMask(16)
      .addParams({
        characterID: characterID
      })
      .setTransform(transform, true)
      .request();
  },

  getContracts: function (apiKey, characterID) {
    "use strict";
    var client = new Veldspar.API.Client("/char/Contracts.xml.aspx"),
      transform = null;

    return client
      .setApiKey(apiKey)
      .requireAccessMask(67108864)
      .addParams({
        characterID: characterID
      })
      .setTransform(transform, true)
      .request();
  }

};