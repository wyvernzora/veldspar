Veldspar = (this ? exports).Veldspar
Kernite = (this ? exports).Kernite

# RT: Root Template
((view) ->
  Kernite.ui view

  # Meteor.js events
  view.events view.attach
    'click #rt-nav-admin-update-data': ->
      Meteor.call 'updateSkillTree', (result, error) ->
        if error
          alert error.reason
        else
          alert 'success!'


  # Meteor.js helpers
  view.helpers
    'view': ->
      if Meteor.user()
        if Session.get('app.character')
          return switch Session.get('character.view')
            when 'skills' then Template.ch_skills
            else Template.character
        else
          return Template.user
      else return Template.login
    'modal': ->
      switch Session.get('app.modal')
        when 'signup' then Template.signup
        when 'add-key' then Template.add_key
        else null
    'navbar': ->
      if Meteor.user()
        if Session.get('app.character')
           return Template.nav_character
        else
          return Template.nav_user
      else return null

  view.onRender -> $('#rt-modal-view').on 'hidden.bs.modal', -> Session.set 'app.modal', null

)(Template.root)
