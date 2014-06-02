# Veldspar EVE Online API Client
# transformer.coffee - JSON Object Transformation
# Copyright © Denis Luchkin-Zhou
Veldspar = (exports ? this).Veldspar
Veldspar.Transformer ?= { }
# Internal: Access a deeply nested property by its property path string.
# Can either assign or retrieve the property value depending on whether
# the value parameter is defined.
#
# obj -     An {Object} whose property to access.
# prop -    A {String} specifying the property path of the target property.
# value -   A new value for the property; leave undefined if you want this
#           function to return the current property value.
#
# Returns current property value when value is undefined; otherwise returns
# nothing.
Veldspar.Transformer.property = (obj, prop, value) ->
  # Make sure that object and prop are defiend
  if (not prop) or (not obj)
    return
  # Convert to dot notation and split property path
  prop = prop.replace /\[(\w+)\]/g, '.$1'
  prop = prop.replace /^\./, ''
  list = prop.split '.'
  # Find the specified property
  while list.length > 1
    n = list.shift()
    # Handle undefined properties
    if _.isUndefined obj[n]
      # ..in case of retrieval, abort
      if _.isUndefined value
        return
      # ..in case of assignment, create empty object
      else
        obj[n] = { }
    obj = obj[n]
  # Perform the operation
  if _.isUndefined value
    obj[list[0]]
  else
    obj[list[0]] = value
# Internal: Transforms a JSON object according to the specified set of rules.
#
# object -  An {Object} to transform.
# rule -    An {Object} that maps the properties of the original object to
#           the properties of the transformed object.
#
# Returns the transformed object.
Veldspar.Transformer.transform = (object, rule) ->
  # Make sure that object is defined
  if not object
    return
  # Undefined rule returns the original object
  if not rule
    object
  # A few shorthands
  result = { }
  # Execute transform
  _.each rule, (k,n) ->
    if n isnt '_path_'
      if _.isString k
        # {String}: set the target property
        Veldspar.Transformer.property result, n, Veldspar.Transformer.property object, k
      else if _.isFunction k
        # {Function}: compute result
        Veldspar.Transformer.property result, n, k object
      else if _.isObject(k) and _.isString(k._path_)
        # {Object}: nested transform
        p = Veldspar.Transformer.property object, k._path_ 
        # If target is an array, transform contents
        if _.isArray p
          arr = []
          _.each p, (i) ->
            arr.push Veldspar.Transformer.transform i, k
          Veldspar.Transformer.property result, n, arr
        else
          Veldspar.Transformer.property result, n, Veldspar.Transformer.transform p, k
      else
        throw new Meteor.Error 19, 'Unexpected transform rule.'
  result
# Internal: Unwraps 'rowset' collections returned by CCP's API into arrays with
# appropriate names. This function will also recursively unwrap any children.
#
# object -  An {Object} to unwrap. 
#
# Returns the unwrapped version of the original object.
Veldspar.Transformer.unwrap = (object) =>
  # Recursively unwrap children first
  _.each object, (k,n) ->
    if object.hasOwnProperty(n) and _.isObject(object[n])
      object[n] = Veldspar.Transformer.unwrap k
  # Unwrap current object
  if object.hasOwnProperty 'rowset'
    if _.isArray object.rowset
      # Unwrap all rowsets in the object
      _.each obj.rowset, (r) ->
        # Force wrap rows into arrays
        if not _.isArray r.row
          r.row = [ r.row ] 
        # Append if already exists
        if not _.isUndefined object[r.name]
          object[r.name] = _.union(object[r.name], r.row)
        else
          object[r.name] = r.row
    else
      # Single rowset, unwrap
      if not _.isArray object.rowset.row
        object.rowset.row = [ object.rowset.row ]
      object[object.rowset.name] = object.rowset.row
    
  # Delete rowset
  object.rowset = undefined
  return object
