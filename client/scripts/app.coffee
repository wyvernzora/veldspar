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
    'admin': 'admin'
    'logout': 'logout'
    'char/:id': 'char'
    'char/:id/:view': 'char'
    'type/:id': 'type'

  # Route callbacks
  home: ->
    Session.set 'app.character', null
    Session.set 'character.view', null
    Session.set 'app.view', null

  admin: ->
    if Meteor.user()?.isAdmin
      Session.set 'app.view', 'admin'

  logout: ->
    Meteor.logout()
    Session.set 'app.character', null
    Session.set 'character.view', null
    Session.set 'app.view', null

  char: (id, view) ->
    char = Veldspar.UserData.characters.findOne _id:id
    oldChar = Session.get 'app.character'
    if char and oldChar isnt char then Session.set 'app.character', id
    oldView = Session.get 'character.view'
    if oldView isnt view then Session.set 'character.view', view

  type: (id) ->

    console.log 'type:' + id
    Session.set 'app.modal', 'type'
    Session.set  'type.id', id
    $('#rt-modal-view').modal 'show'

Veldspar.Router = new veldsparRouter()
Meteor.startup -> Backbone.history.start pushState:yes
