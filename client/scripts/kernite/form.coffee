# Kernite UI - UI framework for Veldspar.io
# form.coffee - Input validation and more
# Copyright © 2014 Denis Luchkin-Zhou <https://github.com/jluchiji>
Kernite = (this ? exports).Kernite ?= { }

###

{
  '#email': {
    'validate': function (value) {
      
    },
    'error': function (error) {
      
    },
    'success': function (value) {
      
    }
  },
  '#password': {
    'validate': function (value) {
      
    },
    'onError': function (error) {
      
    }
  }

}

###


# Form validation handling
class Kernite.Form
  
  # Utility Functions
  @c = (f) ->
    return f() if _.isFunction f
  
  # Class Members
  
  # Public: creates a new instance of the Kernite.Form
  constructor: (inputs) ->
    @inputs = { }
    if _.isObject inputs
      _.extend @inputs, inputs
  
  # Public: validates a specific input, or all inputs if there
  # is no id specified
  #
  # id  - {String} DOM ID of the input to validate; or {undefined}
  validate: (id) -> 
    # if only need to validate a specific input...
    if id and @inputs[id] # check if the input is in the form
      $input = $ id
      meta = @inputs[id]
      value = $input.val()
      # Temporarily remove error box to fix the 'toggle bug'
      if _.isString meta.error
        $(meta.error).hide()
      # Check for errors
      err = meta.validate value if _.isFunction meta.validate
      # Call the correct callback when needed
      if err
        $input.addClass('error').focus()
        if _.isFunction meta.error
          meta.error err # Function callback, call it
        else if _.isString meta.error
          $err = $ meta.error # String arg, this is an error box
          $err.html(err).clearQueue().show().effect('pulsate', times: 2)
        return err
      else
        $input.removeClass 'error'
        if _.isString meta.error
          $(meta.error).hide 'fade'
        meta.success value if meta.success
        return undefined;
    # Validate all inputs
    else
      errs = for input of @inputs
        i = @validate input
        break if i