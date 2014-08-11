###
Veldspar.io - Meteor.js based EveMon alternative
Copyright © 2014 Denis Luchkin-Zhou <https://github.com/jluchiji>
-------------------------------------------------------------------------------
kernite/view.coffee - This file contains the base class for all kernite views.
###
Kernite = (this ? exports).Kernite ?= {}

Kernite.ui = (v) ->
  
  # Utility Namespace
  v.util = (methods) ->
    $.extend v.util, methods
    
  # Callback Extension
  v._kern ?= {}
  v._kern.render ?= []
  v.onRender = (f) ->
    v._kern.render.push f if _.isFunction f
  v.rendered = ->
    _.each v._kern.render, (f) -> f()