# Veldspar EVE Online API Client
# http.coffee - HTTP requesting
class HttpClient
  constructor: (@host, @defaultParams) ->
    @parser = new xml2js.Parser attrkey: '@', emptyTag: null, mergeAttrs: yes, explicitArray: no
  
  request: (method, endpoint, params) ->
    uri = @host + endpoint;
    try
      response = HTTP.call(method, uri, params)
    catch error
      response = error.response
      
    if not response
      throw new Meteor.Error 0, 'Empty response.'
    
    if Veldspar.Config.logResponse
      console.log response.content
      
    if response.statusCode isnt 200
      reason = 'API endpoint did not specify error details.'
      if response.content
        try
          obj = (blocking @parser, @parser.parseString)(response.content)
          reason = obj.eveapi.error._
          response.statusCode = obj.eveapi.error.code
        catch error
          reason = response.content
      throw new Meteor.Error response.statusCode, reason
    
    return (blocking @parser, @parser.parseString)(response.content)
    
  
  