# Kernite UI - UI framework for Veldspar.io
# view.coffee
# Copyright © 2014 Denis Luchkin-Zhou <https://github.com/jluchiji>
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
    
  # Sideviews
  v.left = -> $ '#left'
  v.left.isOpen = no
  v.left.open = (sideview, callback) ->
    Session.set 'sideview', sideview
    $('#gaia, #left').addClass 'show-left', 'normal', ->
      v.left.isOpen = yes
      callback() if _.isFunction callback
    $('#overlay').show 'fade', 'normal'
  v.left.close = (callback) ->
    $('#overlay').hide 'fade', 'normal', ->
      Session.set 'sideview', null
      v.left.isOpen = no
      callback() if _.isFunction callback
    $('#gaia, #left').removeClass 'show-left', 'normal'

  v