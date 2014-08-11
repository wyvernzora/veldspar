Veldspar = (this ? exports).Veldspar
Kernite = (this ? exports).Kernite

# RT: Root Template
((view) ->
  Kernite.ui view
  
  # Meteor.js events
  view.events
    'click #rt-nav-logout': -> Meteor.logout()
  
  # Meteor.js helpers  
  view.helpers
    'view': ->
      if Meteor.user()
        if Session.get('app.character')
           return Template.character
        else
          return Template.user
      else return Template.login
    'modal': ->
      switch Session.get('modal')
        when 'signup' then Template.signup
        else null
  
)(Template.root)