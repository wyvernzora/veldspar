###
Template.hello.events {
  'click input': ->
    Meteor.call 'test', (err, result) ->
      result = err if err
      node = new PrettyJSON.view.Node { data: result, el: $('#result') }
      console.log JSON.stringify result
}
###
Template.header.events {
  'click #navDebug': ->
    Session.set('showDebugView', yes)
  'click #navLogout': ->
    Meteor.logout()
    Session.set('CurrentCharacter', null)
  'click #navHome': ->
    Session.set('CurrentCharacter', null)
  'click #navAdmin': ->
    Meteor.call 'updateSkillTree', (err, result) ->
      if (err) 
        alert err.reason
      else
        alert 'done'
}

Template.debug.events {
  'click #debugBtn': ->
    $wrapper = $('#main-wrapper')
    $wrapper.animate('margin-left': '22%', 20)
}

Template.root.showDebugView = -> Session.get('showDebugView')
Template.root.currentCharacter = -> Session.get('CurrentCharacter');

UI.registerHelper 'currentCharacter', ->
  return Session.get 'CurrentCharacter'