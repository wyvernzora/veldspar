Veldspar = (this ? exports).Veldspar
Kernite = (this ? exports).Kernite

# CH-SKL: Character Skills
Meteor.startup ->
  ((view) ->
    Kernite.ui view

    view.ms =
      refresh: new Veldspar.Refresh '#ch-skl-refresh', 'data.updateSkillQueue'

    view.events
      'click #ch-skl-refresh': ->
        view.ms.refresh.refresh @_id

    view.helpers
      'skillQueue': ->
        _.values _.omit @skillQueue, '_cachedUntil'
      'skillQueueItem': (char) ->
        params =
          skillInfo: Veldspar.StaticData.skillTree.findOne _id:String(@skill.id)
          charSkill: _.binSearch char.skills, @skill, (a, b) -> a.id-b.id
          indicator:
            'level': char.getSkill(@skill.id)?.level ? 0
            'queued': @skill.level
            'training': if @position is 0 then @skill.level
          remainingTime: Veldspar.Timing.diff @start.date, @end.date
          queued: @

      'skillCategories': ->
        char = Veldspar.UserData.characters.findOne _id:Session.get 'app.character'
        # Skip 'Fake Skills' category
        categories = Veldspar.StaticData.skillCategories.find({$nor: [_id:'505']}, {sort: {name: 1}}).fetch()

        for cat in categories
          cat.skills = _.chain(@skills).where(groupID:Number cat._id).sort((a,b)->
            return 1 if a.name > b.name
            return -1 if a.name < b.name
            return 0).value()
          cat.skillPoints = _.chain(cat.skills).pluck('sp').reduce(((i, mem) -> i+mem), 0).value()

        return categories

      'certCategories': ->
        char = Veldspar.UserData.characters.findOne _id:Session.get 'app.character'
        certs = _.chain(Veldspar.StaticData.certificates.find().fetch())
          .groupBy('groupID').map((v,k) -> id:k, certificates:v).value()
        for id, group of certs
          # Resolve category name
          group.name = Veldspar.StaticData.skillCategories.findOne({_id:String(group.id)})?.name ? 'UNKNOWN CATEGORY (BUG): ' + group.id
          # Retrieve certificate levels
          for cert in group.certificates
            cert.level = char.certificates[cert._id] ? 0

        return certs


      # Character Helpers
      'charSkill': (char, skill) ->
        skill = _.binSearch char.skills, skill, (a, b) -> a.id-b.id
        return skill
      'queueParam': (char, q) ->
          'level': _.binSearch(char.skills, q.skill, (a, b) -> a.id-b.id)?.level ? 0
          'queued': q.skill.level
          'training': if q.position is 1 then _.chain(char.skillQueue).find((s) ->
            s.position is 1).value()?.skill.level ? 0 else 0
  )(Template['char-skills'])
