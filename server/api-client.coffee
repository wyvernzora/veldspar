# Veldspar EVE Online API Client
# api-client.coffee - CCP API Client
# Copyright © Denis Luchkin-Zhou
Veldspar = (exports ? this).Veldspar

# Public: Minimalistic EVE Online API Client
class Veldspar.ApiClient
  # Private: Shared instance of HTTP Client
  @httpClient: null
  # Public: Initializes an EVE Online API Client
  #
  # endpoint -  A {String} specifying the URI of the REST endpoint relative
  #             to the host root, with the leading slash.
  #
  # Returns the ApiClient instance.
  constructor: (@endpoint) ->
    ApiClient.httpClient = new Veldspar.HttpClient Veldspar.Config.apiHost, undefined, Veldspar.Config.verbose
    this
  # Public: Sets the player's API Key info
  #
  # apiKey -    An {ApiKey} object
  # 
  # Returns the ApiClient instance.
  key: (@apiKey) ->
    this
  # Public: Specifies the access mask requirements.
  # Also verifies the access mask of the API Key.
  # Inplicitly requires the API Key to be defined and contain an access mask.
  #
  # accessMask -  Access mask 
  # 
  # Returns the ApiClient instance. 
  permission: (accessMask) ->
    # Check for API Key
    if not @apiKey
      throw new Meteor.Error 9, 'API Key required but undefiend!'
    # Check if access mask is defined
    if not @apiKey.accessMask
      throw new Meteor.Error 12, 'Access mask required but undefined!'
    # Check if access mask allows the operation
    if @apiKey.accessMask & accessMask isnt accessMask
      throw new Meteor.Error 11, 'Access mask does not allow this operation!'
    this
  # Public: Sets the transformation rule for the response object.
  #
  # transform -   Transformation rule object. For more detailed format, please
  #               refer to the documentation of the {Transformer}.
  # unwrap -      A {Boolean} specifying whether "rowset" objects should be
  #               unwrapped into arrays. (Default: yes)
  # 
  # Returns the ApiClient instance.
  transform: (@transform, @unwrap = yes) ->
    this
  # Public: Adds parameters to the underlying HTTP call.
  #
  # params -      An {Object} containing additional parameters. For more
  #               detailed format, please refer to the documentation of the
  #               Meteor's HTTP package: http://docs.meteor.com/#HTTP
  # 
  # Returns the ApiClient instance.
  params: (@params) ->
    this
  # Public: Sends the requests and retrieves the response.
  # Parses, unwraps and transforms the response as needed.
  # 
  # Returns the processed response object.
  request: ->
    # HTTP parameters
    params =
      params:
        keyID: @apiKey?.id
        vCode: @apiKey?.code
      headers:
        'User-Agent': 'Veldspar/1.0'
    _.extend params.params, @params
    # Send the request
    raw = ApiClient.httpClient.request('POST', @endpoint, params)
    # Transform as needed
    raw = Veldspar.Transformer.unwrap raw if @unwrap
    raw = Veldspar.Transformer.transform raw, @transform if @transform