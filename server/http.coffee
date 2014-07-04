# Veldspar EVE Online API Client
# http.coffee - HTTP requesting
# Copyright © Denis Luchkin-Zhou
Veldspar = (exports ? this).Veldspar

# Public: Calls remote REST endpoint and converts the XML response into a 
# JavaScript object. Also captures errors and delivers them to the client
# instead of causing a 500 Internal Server Error.
class Veldspar.HttpClient
  # Public: Initialize an HTTP client instance.
  #
  # host -      Hostname of the remote server, including the protocol but
  #             excluding the tailing slash.
  # params -    Default parameters that will be added to the HTTP request.
  #             See http://docs.meteor.com/#HTTP for more details.
  # verbose -   A {Boolean} indicating whether the HTTP client should log
  #             detailed information to the console.
  #
  # Returns nothing.
  constructor: (@host, @params = { }, @verbose = no) ->
    @parser = new xml2js.Parser attrkey: '@', emptyTag: null, mergeAttrs: yes, explicitArray: no
  # Public: Seds an HTTP request to the specified endpoint of the remote
  # host.
  #
  # method -    A {String} specifying which HTTP method to use. For EVE
  #             Online API, it is recommended to use 'POST'.
  # endpoint -  A {String} specifying the relative address of the API
  #             endpoint, including the heading slash.
  # params -    An {Object} with parameters that should be added to this
  #             HTTP request. For more information about the format of the
  #             object, see http://docs.meteor.com/#HTTP
  #
  # Returns the JavaScript object representation of the XML response.
  request: (method, endpoint, params) ->
    # Concaterate URI and merge parameters
    uri = @host + endpoint;
    params = _.extend _.clone(@params), params
    # Log request details to the console
    if @verbose
      console.log method
      console.log uri
      console.log JSON.stringify params
    # Make the request, in case of error replace the response
    try
      response = HTTP.call(method, uri, params)
    catch error
      response = error.response
    # Undefined response, most likely DNS resolution failure
    if not response
      throw new Meteor.Error 999, 'Empty response.'
    # Log the raw response to the console
    if @verbose
      console.log response.content
    # Process the error, assuming CCP specified one in the API response
    if response.statusCode isnt 200
      reason = 'API endpoint did not specify error details.'
      if response.content
        try
          # Parse CCP's error details response
          obj = (blocking @parser, @parser.parseString)(response.content)
          reason = obj.eveapi.error._
          response.statusCode = obj.eveapi.error.code
        catch error
          # If it is not the CCP's response, it's an HTTP error
          reason = response.content
      throw new Meteor.Error response.statusCode, reason
    # Parse the actual response
    return (blocking @parser, @parser.parseString)(response.content)
  