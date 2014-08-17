# TY: Type View
((view) ->
  Kernite.ui view, yes

  view.events

  view.helpers
    'typeInfo': ->
      id = Session.get 'type.id'
      # At this point, only skills are implemented
      return Veldspar.StaticData.skillTree.findOne _id:String(id)



  view.onRender ->
    $('#rt-modal-view').one 'hidden.bs.modal', ->
      Veldspar.Router.navigate '/', trigger:no, replace:yes

)(Template.type)

((view) ->

  view.helpers
    'prereqIndicator': ->
      char = Veldspar.UserData.characters.findOne _id:Session.get('app.character')
      if char
        level = char.getSkill(@id)?.level ? 0
        require = @level
        return level:level, require:require

)(Template.skill_prereq)
