/* Veldspar API CLient - Account Info Module */
Veldspar.API = {



};

/* API Client Class */
Veldspar.API.apiClient = function (endpoint) {
  this.endpoint = Veldspar.Config.endpoint + endpoint;
  return this;
}

Veldspar.API.apiClient.prototype.setApiKey = function (apiKey) {
  
  console.log(JSON.stringify(apiKey));
  
  this.apiKey = apiKey;
  return this;
}

Veldspar.API.apiClient.prototype.requireAccessMask = function (mask) {
  if (_.isUndefined(this.apiKey.accessMask))
    throw new Meteor.Error(12, "Access mask required but undefined! Consider using getApiKeyInfo() first.");
  var a = this.apiKey.accessMask & mask;
  if (a !== mask)
    throw new Meteor.Error(11, "Access mask does not allow such operation!");
  return this;
}

Veldspar.API.apiClient.prototype.setTransform = function (transform, unwrap) {
  if (_.isUndefined(unwrap)) unwrap = true;
  this.unwrap = unwrap;
  this.transform = transform;
  return this;
}

Veldspar.API.apiClient.prototype.addParams = function (params) {
  this.params = params;
  return this;
}

Veldspar.API.apiClient.prototype.request = function () {
  var args = {
    params: {
      keyID: this.apiKey.id,
      vCode: this.apiKey.code
    },
    headers: {
      "User-Agent": "Veldspar/1.0"
    }
  };
  _.extend(args.params, this.params);

  console.log(JSON.stringify(args));
  
  var raw = Veldspar.HTTP.jsonRequest("POST", this.endpoint, args);
  
  if (this.unwrap) raw = Transformer.unwrap(raw, "rowset", "row", "name", true);
  if (this.transform) raw = Transformer.transform(raw, this.transform);
  
  return raw;
}

/* API method calls */
Veldspar.API.AccountInfo = {

  getApiKeyInfo: function (apiKey) {
    var client = new Veldspar.API.apiClient("/account/APIKeyInfo.xml.aspx");
    return client.setApiKey(apiKey).setTransform(Veldspar.Transforms.AccountInfo.apiKeyInfo, true).request();
  },

  getAccountStatus: function (apiKey) {
    var client = new Veldspar.API.apiClient("/account/AccountStatus.xml.aspx");
    return client.setApiKey(apiKey).requireAccessMask(33554432).setTransform(Veldspar.Transforms.AccountInfo.accountStatus, true).request();
  },

  getAccountCharacters: function (apiKey) {
    var client = new Veldspar.API.apiClient("/account/Characters.xml.aspx");
    return client.setApiKey(apiKey).setTransform(Veldspar.Transforms.AccountInfo.accountCharacters, true).request();
  }

}

Veldspar.API.Character = {

  getAccountBalance: function (apiKey, characterID) {
    var client = new Veldspar.API.apiClient("/char/AccountBalance.xml.aspx");
    return client.setApiKey(apiKey).requireAccessMask(1).addParams({
        characterID: characterID
      })
      .setTransform(Veldspar.Transforms.Character.walletBalance, true).request();
  },
  
  getAssetList: function (apiKey, characterID) {
    var client = new Veldspar.API.apiClient("/char/AssetList.xml.aspx");
    return client.setApiKey(apiKey).requireAccessMask(2).addParams({characterID: characterID})
      .setTransform(null, true).request();
  }

}
