Veldspar = (this ? exports).Veldspar
Kernite = (this ? exports).Kernite

# CH-NAV: Character Navigation
((view) ->
  Kernite.ui view

  view.helpers
    'character': ->
      Veldspar.UserData.characters.findOne _id:Session.get 'app.character'

)(Template.nav_character)

# CH: Character View
((view) ->
  Kernite.ui view

  view.ms =
    refresh: new Veldspar.Refresh '#ch-refresh', 'updateCharacterSheet'

  view.events
    'click #ch-refresh': -> view.ms.refresh.refresh @_id

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

  return view
)(Template.character)

# CH-SKL: Character Skills
((view) ->
  Kernite.ui view

  view.ms =
    refresh: new Veldspar.Refresh '#ch-skl-refresh', 'updateSkillQueue'

  view.events
    'click #ch-skl-refresh': ->
      view.ms.refresh.refresh @_id

  view.helpers
    'character': ->
      Veldspar.UserData.characters.findOne _id:Session.get 'app.character'
    'skillQueue': ->
      @skillQueue.sort (a, b) -> a.position - b.position
    'skillQueueItem': (char) ->
      params =
        skillInfo: Veldspar.StaticData.skillTree.findOne _id:String(@skill.id)
        charSkill: _.binSearch char.skills, @skill, (a, b) -> a.id-b.id
        indicator:
          'level': _.binSearch(char.skills, @skill, (a, b) -> a.id-b.id)?.level ? 0
          'queued': @skill.level
          'training': if @position is 1 then _.chain(char.skillQueue).find((s) ->
            s.position is 1).value()?.skill.level ? 0 else 0
        remainingTime: Veldspar.Timing.diff @start.date, @end.date
        queued: @

    'skillCategories': ->
      # Skip 'Fake Skills' category
      categories = Veldspar.StaticData.skillCategories.find({$nor: [_id:'505']}, {sort: {name: 1}}).fetch()
      for cat in categories
        cat.skills = _.chain(@skills).where(groupID:Number cat._id).sort((a,b)->
          return 1 if a.name > b.name
          return -1 if a.name < b.name
          return 0).value()
        cat.skillPoints = _.chain(cat.skills).pluck('sp').reduce(((i, mem) -> i+mem), 0).value()
      return categories


    # Character Helpers
    'charSkill': (char, skill) ->
      skill = _.binSearch char.skills, skill, (a, b) -> a.id-b.id
      return skill
    'queueParam': (char, q) ->
        'level': _.binSearch(char.skills, q.skill, (a, b) -> a.id-b.id)?.level ? 0
        'queued': q.skill.level
        'training': if q.position is 1 then _.chain(char.skillQueue).find((s) ->
          s.position is 1).value()?.skill.level ? 0 else 0


)(Template.ch_skills)
