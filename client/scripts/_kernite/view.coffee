###
Veldspar.io - Meteor.js based EveMon alternative
Copyright © 2014 Denis Luchkin-Zhou <https://github.com/jluchiji>
-------------------------------------------------------------------------------
kernite/view.coffee - This file contains the base class for all kernite views.
###
Kernite = (this ? exports).Kernite ?= {}

Kernite.ui = (v, modal) ->

  # Flags
  v.isModal = modal

  # Utility Namespace
  v.util = (methods) ->
    $.extend v.util, methods
  v.util.applyValidationStyle = (id, result) ->
    $input = $(id)
    if result is 'ok'
      $input.removeClass('has-error has-warning').addClass 'has-feedback has-success'
    else if result is 'warning'
      $input.removeClass('has-error has-success').addClass 'has-feedback has-warning'
    else if result is 'error'
      $input.removeClass('has-success has-warning').addClass 'has-feedback has-error'
    else
      $input.removeClass('has-success has-warning has-error has-feedback')

  # Callback Extension
  v._kern ?= {}
  v._kern.render ?= []
  v.onRender = (f) ->
    v._kern.render.push f if _.isFunction f
  v.rendered = ->
    _.each v._kern.render, (f) -> f()

  v.onRender -> $('body').scrollTop 0 if not v.isModal

  # Modal control
  v.modal =
    show: (name) ->
      Session.set 'app.modal', name
      $('#rt-modal-view').modal 'show'

  # Event Attachment
  v.attach = (events) ->
    map =
      'click .kern-link': (e) ->
        link = $(e.currentTarget).attr('href')
        console.log 'kern-link: ' + link
        Router.go link
    return _.extend events, map
