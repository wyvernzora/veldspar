###!
Veldspar.io - Meteor.js based EveMon alternative
Copyright © 2014 Denis Luchkin-Zhou
-------------------------------------------------------------------------------
app.coffee - Application initialization
###
Kernite = (this ? exports).Kernite
Veldspar = (this ? exports).Veldspar

# Backbone.Router setup
veldsparRouter = Backbone.Router.extend
  routes:
    '': 'home'
    'logout': 'logout'
    'char/:id': 'char'
    'char/:id/:view': 'char'
    'modal/:view': 'modal'
    'type/:id': 'type'

  # Route callbacks
  home: ->
    Session.set 'app.character', null
    Session.set 'character.view', null

  logout: ->
    Meteor.logout()
    Session.set 'app.character', null
    Session.set 'character.view', null

  char: (id, view) ->
    char = Veldspar.UserData.characters.findOne _id:id
    oldChar = Session.get 'app.character'
    if char and oldChar isnt char then Session.set 'app.character', id
    oldView = Session.get 'character.view'
    if oldView isnt view then Session.set 'character.view', view

  type: (id) ->


Veldspar.Router = new veldsparRouter()
Meteor.startup -> Backbone.history.start pushState:yes
