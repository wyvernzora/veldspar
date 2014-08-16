###!
Veldspar.io - Meteor.js based EveMon alternative
Copyright © 2014 Denis Luchkin-Zhou
-------------------------------------------------------------------------------
controls.coffee - Reusable control logic
###
Veldspar = (this ? exports).Veldspar
Kernite = (this ? exports).Kernite

# Refresh handler that calls a meteor method and displays
# animation/appropriate icons
class Veldspar.Refresh extends Kernite.MultiState

  constructor: (@element, @method) ->
    super(@element + ' i') # Multistate is applied to the i element
    @addState 'default', 'ion-refresh', null
    @addState 'refreshing', 'ion-refreshing', null
    @addState 'error', 'ion-alert', 'text-danger',
      => _.delay (=> @state 'default'), 3000
    @addState 'success', 'ion-checkmark', 'text-success',
      => _.delay (=> @state 'default'), 3000

  refresh: (args) ->
    # Only allow refreshing if current state is default
    return no if @current isnt 'default'
    @state 'refreshing'
    Meteor.call @method, args, (error) =>
      if error
        @state 'error'
        console.log error
      else
        @state 'success'

class Veldspar.FormField extends Kernite.MultiState

  constructor: (@element) ->
    super(@element)
    @addState 'ok', 'has-feedback', 'has-success', null
    @addState 'warning', 'has-feedback', 'has-warning', null
    @addState 'error', 'has-feedback', 'has-error', =>
      $(@element + ' i').clearQueue().effect 'pulsate', times:2
      $(@element + ' input').focus().select()
