###
Veldspar.io - Meteor.js based EveMon alternative
Copyright © 2014 Denis Luchkin-Zhou <https://github.com/jluchiji>
-------------------------------------------------------------------------------
kernite/app.coffee - Application scaffolding and such
###
Kernite = (this ? exports).Kernite ?= { }


class Kernite.App

  constructor: ->
    @views = { }
    @viewFactory = { }

  init: ->
    for name, params of @viewFactory
      @views[name] = params.factory params.template

  reg: (name, template, factory) ->
    @viewFactory[name] = template:template, factory:factory

  get: (name) ->
    return @viewFactory[name] if @viewFactory[name]
    console.log 'Kernite.App: view not found - ' + name
    return null # Meteor expects null, not undefined
