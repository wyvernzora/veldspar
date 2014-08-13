Veldspar = (this ? exports).Veldspar
Kernite = (this ? exports).Kernite

# CH-NAV: Character Navigation
((view) ->

  view.events
    'click #ch-nav-skills': -> Session.set 'character.view', 'skills'

  view.helpers
    'character': ->
      Veldspar.UserData.characters.findOne _id:Session.get 'app.character'

)(Template.nav_character)

# CH: Character View
((view) ->
  Kernite.ui view

  view.events
    'click #ch-nav-back': -> Session.set 'app.character', null

  view.helpers
    'character': ->
      Veldspar.UserData.characters.findOne _id:Session.get 'app.character'
    'refreshIconStyle': ->
      switch Session.get 'character.loading'
        when 'refreshing' then 'ion-refreshing'
        when 'success' then 'text-success ion-checkmark'
        when 'error' then 'text-danger ion-alert'
        else 'ion-refresh'
    'dob': ->
      @dob.toLocaleDateString()

)(Template.character)

# CH-SKL: Character Skills
((view) ->
  Kernite.ui view

  view.ms =
    refresh: (new Kernite.MultiState('#ch-skl-refresh i')
      .addState('refreshing', 'ion-refreshing', null)
      .addState('success', 'ion-checkmark text-success',
        -> _.delay((-> view.ms.refresh.state 'default'), 3000))
      .addState('error', 'ion-alert text-danger', null)
      .addState('default', 'ion-refresh', null))

  view.events
    'click #ch-skl-refresh': ->
      return if view.ms.refresh.current isnt 'default'  # already refreshing
      view.ms.refresh.state 'refreshing'
      Meteor.call 'updateSkillQueue', @_id, (error) ->
        if error then view.ms.refresh.state 'error'
        else view.ms.refresh.state 'success'

  view.helpers
    'character': ->
      Veldspar.UserData.characters.findOne _id:Session.get 'app.character'
    'skillQueue': ->
      @skillQueue.sort (a, b) -> a.position - b.position
    'skillInfo': ->
      skill = Veldspar.StaticData.skillTree.findOne _id:@skill.id.toString()
      return skill ? name:'Unknown Skill (BUG)'

)(Template.ch_skills)
