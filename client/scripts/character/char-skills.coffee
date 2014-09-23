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

      # Character Helpers
      'charSkill': (char, skill) ->
        skill = Veldspar.UserData.skills.findOne _id: String(char.id) + '.' + String(skill.id)
        return skill
      'queueParam': (char, q) ->
          'level': Veldspar.UserData.skills.findOne(_id: String(char.id) + '.' + String(skill.id))?.level ? 0
          'queued': q.skill.level
          'training': if q.position is 1 then _.chain(char.skillQueue).find((s) ->
            s.position is 1).value()?.skill.level ? 0 else 0

  )(Template['char-skills'])

# CH-SKL-Q: Skill Queue Page
Meteor.startup ->
  ((view) ->

    view.helpers
      'skillQueue': ->
        _.values _.omit @skillQueue, '_cachedUntil'
      'skillIcon': -> '/svg/skills/book-default.svg'
      'skillQueueItem': (char) ->
        params =
          skillInfo: Veldspar.StaticData.skills.findOne _id:String(@skill.id)
          charSkill: Veldspar.UserData.skills.findOne _id:String(char.id)+'.'+String(@skill.id)
          indicator:
            'level': Veldspar.UserData.skills.findOne(_id:String(char.id)+'.'+String(@skill.id))?.level ? 0
            'queued': @skill.level
            'training': if @position is 0 then @skill.level
          remainingTime: if @position is 0
              Veldspar.Timing.diff Session.get('app.now'), @end.date
            else
              Veldspar.Timing.diff @start.date, @end.date
          queued: @

  )(Template['char-skills-queue'])

# CH-SKL-M: My Skills
Meteor.startup ->
  ((view) ->

    view.helpers
      'skillCategories': ->
        char = Veldspar.UserData.characters.findOne _id:Session.get 'app.character'
        skills = Veldspar.UserData.skills.find({$nor: [group: 'Fake Skills']}, {sort: {name: 1}}).fetch()
        groups = _.chain(skills).groupBy('group').map((v, k) -> {name: k, skills: v})
          .sort(Veldspar.util.compare.byName).value()
        for group in groups
          group.skillPoints = _.chain(group.skills).pluck('sp').reduce(((i, mem) -> mem + i), 0).value()
          group.tag = group.name.replace ' ', '-'
        return groups
      'skillStyle': ->
        if @level is 5 then return 'success'
      'skillIcon': ->
        lv = @?.level ? 0
        if lv is 5 then '/svg/skills/book-level-v.svg'
        else if @sp isnt Veldspar.util.skill.sp(lv, @rank) then return '/svg/skills/book-partial.svg'
        else '/svg/skills/book-default.svg'

  )(Template['char-skills-my'])

# CH-SKL-C: Certificates
Meteor.startup ->
  ((view) ->

    view.helpers
      'certGroups': ->
        certs = _.chain(Veldspar.StaticData.certificates.find({}, {sort: {name: 1}}).fetch())
          .groupBy('group').map((v,k) -> name:k, certificates:v, tag:k.replace(' ', '-'))
          .sort(Veldspar.util.compare.byName).value()

        for group in certs
          for cert in group.certificates
            cert.level = @certificates[Number cert._id] if @?.certificates

        return certs
      'certStyle': ->
        if @level is 5 then 'success'
        else if @level is 0 then 'not-injected'

  )(Template['char-skills-certificates'])
