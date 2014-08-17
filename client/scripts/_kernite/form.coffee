###
Veldspar.io - Meteor.js based EveMon alternative
Copyright © 2014 Denis Luchkin-Zhou <https://github.com/jluchiji>
-------------------------------------------------------------------------------
kernite/form.coffee - Form validation/submission utilities.
###
Kernite = (this ? exports).Kernite ?= {}

###

  'success': (data) -> On success validation/submission; data is an object of id:value pairs
  'error': (errors, id) -> On validation/submission error; error has an id property to indicate origin of error
  'submit': (data) -> Submission routine

  'fields':
    '#email':
      'update': (result, description) -> ... Called for {keyup} event
      'validate': (value) -> ...
      'error': (error, next) -> ...
      'success': (value, next) -> ...
      'next': ID of the next field
      'value': -> Function to get the value; defaults to '$(id).val()'
    '#password':
      'validate': (value) -> ...
      'error': (error) -> ...
      'success': (value) -> ...

###

# Kernite.Form class
# Simplifies complex form validation and submission.
class Kernite.Form

  constructor: (options) ->
    # No options, no form
    return if not options
    # Copy callbacks
    @_success = _.bind options.success, @ if _.isFunction options.success
    @_error = _.bind options.error, @ if _.isFunction options.error
    @_submit = _.bind options.submit, @ if _.isFunction options.submit
    # Copy field data
    @fields = options.fields ? {}
    # Bind all callbacks to the form
    for id, meta of @fields
      for name, callback of meta
        meta[name] = _.bind(callback, @) if _.isFunction(callback)

  validate: (id) ->
    # Check that this is a valid id
    return if (not id) or (not @fields[id])
    # Start validation
    meta = @fields[id]
    value = if _.isFunction(meta.value) then meta.value() else $(id).val()
    # Check for errors
    error = meta.validate value if _.isFunction meta.validate
    error.id = id if error
    if error and (error.critical isnt no)
      if _.isFunction(meta.error)
        meta.error error
      else if _.isFunction(@_error)
        @_error [error]
    else
      if _.isFunction(meta.success)
        meta.success value
      else if _.isFunction(@_success)
        data = {}
        data[id] = value
        @_success data

      if _.isString(meta.next)
        $(meta.next).focus()
      else
        @submit()

  update: (id) ->
    # Check that this is a valid id and options are specified
    return if (not id) or (not @fields[id])
    # Start validation
    meta = @fields[id]
    value = if _.isFunction(meta.value) then meta.value() else $(id).val()
    # Check for errors
    error = meta.validate value if _.isFunction meta.validate
    if error
      meta.update error.type, error.reason if _.isFunction meta.update
    else
      meta.update 'ok', null if _.isFunction meta.update

  submit: ->
    # Handle no callback case
    return if (not @_submit)
    # Gather data and validate
    data = { }
    error = []
    critical = no
    _.each @fields, (meta, id) ->
      # Get the value and validate it
      value = if _.isFunction(meta.value) then meta.value() else $(id).val()
      err = meta.validate value if _.isFunction meta.validate
      if err
        err.id = id
        error.push err
        critical = yes if (err.critical isnt no) # Abort submission
      data[meta.name ? id] = value
    # Call appropriate callback
    if critical
      @_error error, null if _.isFunction @_error
    else
      @_submit data

  error: (id, type, reason) ->
    if _.isFunction(@fields[id]?.error)
      @fields[id].error id:id, type:type, reason:reason
    else if _.isFunction(@_error)
      @_error [id:id, type:type, reason:reason]

  attach: (events) ->
    map = { } # Temporary event map
    form = @  # Preserve access to the form instance
    # Attach event handlers to the temporary event map
    _.each @fields, (meta, id) ->
      # Attach update handler if needed
      if _.isFunction(meta.update)
        map['keyup ' + id] = -> form.update id
      # Attach validate handler
      map['keydown ' + id] = (e) -> form.validate id if e.keyCode is 13
    # Move event handlers to the actual event map
    _.extend events, map
    # Return the event map
    return events
