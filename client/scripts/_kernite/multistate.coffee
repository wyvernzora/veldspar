###
Veldspar.io - Meteor.js based EveMon alternative
Copyright © 2014 Denis Luchkin-Zhou <https://github.com/jluchiji>
-------------------------------------------------------------------------------
kernite/multistate.coffee - Multi-state UI components
###
Kernite = (this ? exports).Kernite ?= { }

class Kernite.MultiState

  constructor: (@selector) ->
    @states ?= { }
    @classes = ''
    @current = 'default'
    @addState 'default', '', null # Default state

  addState: (name, classes..., callback) ->
    @states[name] = class:classes, callback:callback
    @classes = _.chain(@states).pluck('class').flatten().uniq().join(' ').value()
    return @

  state: (name) ->
    $target = $(@selector)
    $target.removeClass @classes
    if @states[name]
      $target.addClass @states[name].class.join(' ') if @states[name].class
      @states[name].callback(@current, name) if @states[name].callback
      @current = name
    else
      console.log 'Kernite.MultiState: not found - ' + name
      @current = null
    return @
