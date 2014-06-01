# Veldspar EVE Online API Client
# api-client.coffee - CCP API Client
# Copyright © Denis Luchkin-Zhou
Veldspar = exports ? this

class Veldspar.ApiClient
  
  @httpClient: null
  
  constructor: (@endpoint) ->
    ApiClient.httpClient = new Veldspar.HttpClient 'https://api.eveonline.com'
    this
    
  setApiKey: (@apiKey) ->
    this
    
  requirePermission: (accessMask) ->
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
  
  setTransform: (@transform, @unwrap = yes) ->
    this
  
  addParams: (@params) ->
    this
  
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
    raw = Transformer.unwrap raw if @unwrap
    raw = Transformer.transform raw, @transform if @transform