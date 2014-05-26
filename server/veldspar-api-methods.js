/* API method calls */
Veldspar.API.AccountInfo = {

  getApiKeyInfo: function (apiKey) {
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

}

Veldspar.API.Character = {

  getAccountBalance: function (apiKey, characterID) {
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
  }

}