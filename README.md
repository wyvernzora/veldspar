#Veldspar
Veldspar is a [Meteor.js](http://meteor.com) based EVE Online account manager. It is also the JavaScript API client that powers the Veldspar application behind the scenes.

Currently the Veldspar project is still in early development.

##Request Pipeline
In general, each response goes through the following steps:
```
Composition ➠ Cache ➠ Seding ➠ Receiving ➠ XML Parsing ➠ Unwrapping ➠ Transformation ➠ Return
```

**Composition** is a step where information such as API Key and required access mask is gathered and checked for errors.

[WIP]**Cache** step is where the client checks the request information against the cache, and if the caching time indicated by CCP has not lapsed, transparently returns the cached version instead of sending a new request.

**Sending** is self explanatory.

**Receiving** is self explanatory. HTTP errors and CCP-returned errors are raised here.

**XML Parsing** step is where the XML response text is parsed into a JSON object that can be understood and manipulated by JavaScript.

**Unwrapping** step is where unnecessary `rowset` objects are stripped down and the structure of the response object is simplified.

**Transformation** step is where the response object is rearranged in a fashion somewhat similar to the XLST transformation the EVEMon does. This is done to make the structure of the response object even simpler and more sensible.

**Return** is when the simplified response object is pushed into cache and returned to the client for displaying.


##About API keys for debugging...
Obviously, my own API keys are not included in this repository. In order to add your own for debugging purposes, paste it into a `.apikey.json` file and put it into the `private` directory of the project. Then, change the path to the file in the `server/main.js`.

Format of the api key file should be like this:
```
{
  "id": <api key id>,
  "code": <api key verification code>,
  "accessMask": <api key access mask>,
  "characterID": <id of the character you wish to test with>
}
```