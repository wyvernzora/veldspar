Veldspar = (this ? exports).Veldspar
Kernite = (this ? exports).Kernite

# UR: User View
((view) ->
  Kernite.ui view

  view.ms =
    refresh: (new Kernite.MultiState('#ur-refresh i')
      .addState('refreshing', 'ion-refreshing', null)
      .addState('success', 'ion-checkmark text-success',
        -> _.delay((-> view.ms.refresh.state 'default'), 3000))
      .addState('error', 'ion-alert text-danger', null)
      .addState('default', 'ion-refresh', null))

  view.events
    # Replace broken portraits with generic ones
    'error img': (e) ->
      $(e.currentTarget).attr 'src', '/character.svg'
    # Character Operations
    'click .view-char': ->
      Session.set 'app.character', @_id
    # Toolbar actions
    'click #ur-add-key': ->
      view.modal.show 'add-key'
    'click #ur-refresh': ->
      return if view.ms.refresh.current isnt 'default'  # already refreshing
      view.ms.refresh.state 'refreshing'
      Meteor.call 'updateUserView', (error) ->
        if error then view.ms.refresh.state 'error'
        else view.ms.refresh.state 'success'

  view.helpers
    # Data providers
    'characters': ->
      Veldspar.UserData.characters.find type:'Character'
    'corporations': ->
      Veldspar.UserData.characters.find type:'Corporation'
    # Character Skill-in-training providers
    'skillName': ->
      id = this.skillInTraining?.skill.id
      if id
        return Veldspar.StaticData.skillTree.findOne({_id: String(id)}).name +
          ['', ' I', ' II', ' III', ' IV', ' V'][this.skillInTraining?.skill.level]
      else
        return null
    'percent': ->
      info = this.skillInTraining
      if info and info.active then Veldspar.Timing.progress info else 0
    'timeLeft': ->
      info = this.skillInTraining
      if info and info.active
        _.template '<%= day %>d <%= hour %>h <%= minute %>m <%= second %>s', Veldspar.Timing.diff info.now, info.end.date
      else
        return null
    # UI styling
    'refreshIconStyle': ->
      switch Session.get 'user.loading'
        when 'refreshing' then 'ion-refreshing'
        when 'success' then 'text-success ion-checkmark'
        when 'error' then 'text-danger ion-alert'
        else 'ion-refresh'

  view.onRender ->
    Session.set 'character.view', null


)(Template.user)

# UR-NAV: User View Menu
((view) ->
  Kernite.ui view
  view.events 'click #ur-nav-add-key': -> view.modal.show 'add-key'
)(Template.nav_user)
