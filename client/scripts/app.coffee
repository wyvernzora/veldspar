###!
Veldspar.io - Meteor.js based EveMon alternative
Copyright © 2014 Denis Luchkin-Zhou
-------------------------------------------------------------------------------
app.coffee - Application initialization
###
Kernite = (this ? exports).Kernite
Veldspar = (this ? exports).Veldspar

# Set up iron-router
Router.configure
  layoutTemplate: 'root'
  loadingTemplate: 'loading'

# Set up global hooks

# Set up the application
Router.map ->
  # User home page
  @route 'home',
    path:'/'
    template: 'user'
    waitOn: ->
      Meteor.subscribe 'user.Characters'
    data: ->
      characters: Veldspar.UserData.characters.find type:'Character'
      corporations: Veldspar.UserData.characters.find type:'Corporation'
  # Character Sheet
  @route 'char-sheet',
    path:'/char/:_id'
    waitOn: ->
      return [Meteor.subscribe('user.Characters'), Meteor.subscribe('user.NpcStandings', @params._id)]
    data: ->
      return Veldspar.UserData.characters.findOne('_id':@params._id) ? null
  # Character Skills
  @route 'char-skills',
    path:'/char/:_id/skills'
    waitOn: ->
      Meteor.subscribe 'user.Characters'
    data: ->
      return Veldspar.UserData.characters.findOne('_id':@params._id) ? null
  # Administrator Panel
  @route 'admin',
    path: '/admin'

# Startup code
Meteor.startup ->
  # Calibrate timer
  Veldspar.Timing.calibrate()
  # Set global timer
  Session.set 'app.now', Veldspar.Timing.eveTime()
  # Auto update global timer
  Meteor.setInterval (-> Session.set 'app.now', Veldspar.Timing.eveTime()), 1000
