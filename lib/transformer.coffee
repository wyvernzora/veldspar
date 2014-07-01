# Veldspar EVE Online API Client
# transformer.coffee - JSON Object Transformation
# Copyright © Denis Luchkin-Zhou
Veldspar = (exports ? this).Veldspar
Transformer = Veldspar.Transformer ?= { }
# Prefix store, basically a collection of named conversion methods
Transformer.Prefix ?= { }
# Internal: Registers a prefix function for processing values during
# transformation.
#
# name -    A {String} name for the function
# func -    A {Function} that takes an {Object} as argument, and returns
#           whatever result of the transformation is. Deletes the prefix
#           function if this argument is undefined
Transformer.Prefix.register = (name, func) ->
  Transformer.Prefix[name] = func if name
# Internal: Applies a prefix function to the specified object.
#
# name -    A {String} name for the function
# obj -     The {Object} to transform.
#
# Returns the resulting transformation.
Transformer.Prefix.apply = (name, obj) ->
  # Undefined prefix means no prefix
  if not name 
    return obj
  # Process
  f = Transformer.Prefix[name]
  if f 
    return f(obj)
  else
    throw new Meteor.Error 16, 'Unrecognized prefix.'
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
Transformer.property = (obj, prop, value) ->
  # Make sure that object and prop are defiend
  if (not prop) or (not obj)
    return
  # Attempt to get the type parameter
  prefix = undefined
  args = prop.split ':'
  if args.length is 2
    prefix = args[0]
    prop = args[1]
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
    return null if not obj
    return Transformer.Prefix.apply prefix, obj[list[0]]
  else
    obj[list[0]] = Transformer.Prefix.apply prefix, value
# Internal: Transforms a JSON object according to the specified set of rules.
#
# object -  An {Object} to transform.
# rule -    An {Object} that maps the properties of the original object to
#           the properties of the transformed object.
#
# Returns the transformed object.
Transformer.transform = (object, rule) ->
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
    if n isnt '$path'
      if _.isString k
        # {String}: set the target property
        Transformer.property result, n, Transformer.property object, k
      else if _.isFunction k
        # {Function}: compute result
        Transformer.property result, n, k object
      else if _.isObject(k) and _.isString(k.$path)
        # {Object}: nested transform
        p = Transformer.property object, k.$path 
        # If target is an array, transform contents
        if _.isArray p
          arr = []
          _.each p, (i) ->
            arr.push Transformer.transform i, k
          Transformer.property result, n, arr
        else
          Transformer.property result, n, Transformer.transform p, k
      else
        throw new Meteor.Error 19, 'Unexpected transform rule.'
  result
# Internal: Unwraps 'rowset' collections returned by CCP's API into arrays with
# appropriate names. This function will also recursively unwrap any children.
#
# object -  An {Object} to unwrap. 
#
# Returns the unwrapped version of the original object.
Transformer.unwrap = (object) =>
  # Recursively unwrap children first
  _.each object, (k,n) ->
    if object.hasOwnProperty(n) and _.isObject(object[n])
      object[n] = Transformer.unwrap k
  # Unwrap current object
  if object.hasOwnProperty 'rowset'
    if _.isArray object.rowset
      # Unwrap all rowsets in the object
      _.each object.rowset, (r) ->
        # Force wrap rows into arrays
        if not r.row
          r.row = []
        else if not _.isArray r.row
          r.row = [ r.row ] 
        # Append if already exists
        if not _.isUndefined object[r.name]
          object[r.name] = _.union(object[r.name], r.row)
        else
          object[r.name] = r.row
    else
      # Single rowset, unwrap
      if not object.rowset.row
        object.rowset.row = []
      else if not _.isArray object.rowset.row
        object.rowset.row = [ object.rowset.row ]
      object[object.rowset.name] = object.rowset.row
    
  # Delete rowset
  object.rowset = undefined
  return object

# Internal: 'number' prefix function, converts the object to a number.
#
# obj -   The {String} that needs to be converted.
#
# Returns the number representation of the string; or {undefined} if
# obj is undefined.
Transformer.Prefix.register 'number', (obj) -> 
  return obj if not obj
  return Number(obj)
# Internal: 'bool' prefix function, converts the object to a boolean.
#
# obj -   The {String} that needs to be converted.
#         '1' for true, '0' for false.
#
# Returns the boolean representation of the string; or {undefined} if
# obj is undefined.
Transformer.Prefix.register 'bool', (obj) -> 
  obj is '1'
# Internal: 'booln' prefix function, converts the object to a boolean
# and negates the result.
#
# obj -   The {String} that needs to be converted.
#         '1' for false, '0' for true.
#
# Returns the boolean representation of the string; or {undefined} if
# obj is undefined.
Transformer.Prefix.register 'booln', (obj) -> 
  obj is '0'
# Internal: 'date' prefix function, converts the object to a datetime.
#
# obj -   The {String} that needs to be converted.
#
# Returns the {Date} representation of the string; or {undefined} if
# obj is undefined.
Transformer.Prefix.register 'date', (obj) -> 
  return undefined if not obj
  v = obj.match /(\d{4})-(\d{2})-(\d{2}) (\d{2})\:(\d{2})\:(\d{2})/
  return new Date Number(v[1]), Number(v[2]), Number(v[3]), Number(v[4]), Number(v[5]), Number(v[6])