/* Veldspar API CLient - Account Info Module */
Veldspar.API = {};

/* API Client Class */
if (_.isUndefined(Veldspar.API.Client)) {
  
  Veldspar.API.Client = function (endpoint) {
    this.endpoint = Veldspar.Config.endpoint + endpoint;
    return this;
  };

  Veldspar.API.Client.prototype.setApiKey = function (apiKey) {
    this.apiKey = apiKey;
    return this;
  };

  Veldspar.API.Client.prototype.requireAccessMask = function (mask) {
    if (_.isUndefined(this.apiKey.accessMask))
      throw new Meteor.Error(12, "Access mask required but undefined! Consider using getApiKeyInfo() first.");
    var a = this.apiKey.accessMask & mask;
    if (a !== mask)
      throw new Meteor.Error(11, "Access mask does not allow such operation!");
    return this;
  };

  Veldspar.API.Client.prototype.setTransform = function (transform, unwrap) {
    if (_.isUndefined(unwrap)) unwrap = true;
    this.unwrap = unwrap;
    this.transform = transform;
    return this;
  };

  Veldspar.API.Client.prototype.addParams = function (params) {
    this.params = params;
    return this;
  };

  Veldspar.API.Client.prototype.request = function () {
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
  };
  
}