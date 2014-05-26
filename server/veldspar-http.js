/* Veldspar Utilities */

if (_.isUndefined(Veldspar.HTTP)) {
  
  Veldspar.HTTP = { };
  
  Veldspar.HTTP.parser = new xml2js.Parser({
    attrkey: "@",
    emptyTag: null,
    explicitArray: false,
    mergeAttrs: true
  });
  
  Veldspar.HTTP.parseXml = function (xml) {
    return blocking(this.parser, this.parser.parseString)(xml);
  };
  
  Veldspar.HTTP.jsonRequest = function (method, uri, params) {
    "use strict";
    var response, obj;
    /* EVE Online API returns a response even if request is unsuccessful */
    try { response = HTTP.call(method, uri, params); }
    /* If an error occurs, replace response for parsing */
    catch (error) { response = error.response; }
    /* Make sure the response is defined (is there need to?) */
    if (!response) { throw new Meteor.Error(0, "Undefined response."); }
    /* Error processing */
    if (response.statusCode !== 200) {
      var reason = "API endpoint did not return an error response.";
      if (response.content) {
        obj = this.parseXml(response.content);
        reason = obj.eveapi.error._;
        response.statusCode = obj.eveapi.error.code;
      }
      throw new Meteor.Error(response.statusCode, reason);
    }
    /* Parse content */
    obj = this.parseXml(response.content);
    return obj;
  }
  
}