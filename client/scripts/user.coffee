Veldspar = (this ? exports).Veldspar
Kernite = (this ? exports).Kernite

# UR: User View
((view) ->
  Kernite.ui view

  view.refresh = new Veldspar.Refresh '#ur-refresh', 'updateUserView'

  view.events
    # Replace broken portraits with generic ones
    'error img': (e) ->
      $(e.currentTarget).attr 'src', '/character.svg'
    # Toolbar actions
    'click #ur-add-key': ->
      view.modal.show 'add-key'
    'click #ur-refresh': ->
      view.refresh.refresh()

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
        return Veldspar.Timing.diff info.now, info.end.date
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
    Veldspar.Router.navigate '/', trigger:yes, replace:yes


)(Template.user)

# UR-NAV: User View Menu
((view) ->
  Kernite.ui view
  view.events 'click #ur-nav-add-key': -> view.modal.show 'add-key'
)(Template.nav_user)
