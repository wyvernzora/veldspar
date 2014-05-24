/* This file contains transformation rules for all CCP API calls */

/* Container for some recursive transforms */
Veldspar.Transforms = {

};

Veldspar.Transforms.recursiveAsset = {
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
}

Veldspar.Transforms.asset = {
  "_path_": "eveapi.result.assets",
  "id": "itemID",
  "locationID": "locationID",
  "typeID": "typeID",
  "quantity": "quantity",
  "flag": "flag",
  "stackable": function (o) {
    var singleton = Transformer.getProperty(o, "singleton");
    return !singleton;
  },
  "rawQuantity": "rawQuantity",
  "contents": Veldspar.Transforms.recursiveAsset
}

/* Recursion hack.. for now */
Veldspar.Transforms.recursiveAsset.contents = Veldspar.Transforms.recursiveAsset;

/* Account Info */
Veldspar.Transforms.AccountInfo = {

  apiKeyInfo: {

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

  },

  accountStatus: {

    "_currentTime": "eveapi.currentTime",
    "_cachedUntil": "eveapi.cachedUntil",

    "paidUntil": "eveapi.result.paidUntil",
    "createDate": "eveapi.result.createDate",
    "logonCount": "eveapi.result.logonCount",
    "logonMinutes": "eveapi.result.logonMinutes"

  },

  accountCharacters: {

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
  }

}

Veldspar.Transforms.Character = {

  walletBalance: {
    "_currentTime": "eveapi.currentTime",
    "_cachedUntil": "eveapi.cachedUntil",
    "accounts": {
      "_path_": "eveapi.result.accounts",
      "id": "accountID",
      "key": "accountKey",
      "balance": "balance"
    }
  },

  assetList: {
    "_currentTime": "eveapi.currentTime",
    "_cachedUntil": "eveapi.cachedUntil",
    "assets": Veldspar.Transforms.asset
  },

  contactList: {

  }
}