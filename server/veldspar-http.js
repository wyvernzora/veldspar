/* Veldspar Utilities */


Veldspar.HTTP = {
  
  parser : new xml2js.Parser({
    attrkey: "@",
    emptyTag: null,
    explicitArray: false,
    mergeAttrs: true
  }),
  
  parseXml : function (xml) {
    return blocking(Veldspar.HTTP.parser, Veldspar.HTTP.parser.parseString)(xml);
  },
  
  /* Calls a remote HTTP endpoint.
        method : HTTP method to use (POST, GET, etc.)
        uri    : Full URI of the endpoint.
        params : Request parameters, see HTTP.call() for Meteor's HTTP package.
     Returns
        A JavaScript object created from the returned XML. */
  jsonRequest : function (method, uri, params) {
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
        obj = Veldspar.HTTP.parseXml(response.content);
        reason = obj.eveapi.error._;
        response.statusCode = obj.eveapi.error.code;
      }
      throw new Meteor.Error(response.statusCode, reason);
    }
    
    /* Parse content */
    obj = Veldspar.HTTP.parseXml(response.content);
    
    return obj;
  },
  
 
};