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
}

Template.debug.events {
  'click #debugBtn': ->
    $wrapper = $('#main-wrapper')
    $wrapper.animate('margin-left': '22%', 20)
  
}

Template.root.showDebugView = -> Session.get('showDebugView')

# A trick to force-hide sidebar on logout
Deps.autorun ->
  if not Meteor.user()
    $wrapper = $('#main-wrapper')
    $wrapper.animate('margin-left': '0', 'fast')
    
  