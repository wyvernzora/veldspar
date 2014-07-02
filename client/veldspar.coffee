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
  
}

Template.debug.events {
  'click #debugBtn': ->
    $wrapper = $('#main-wrapper')
    $wrapper.animate('margin-left': '17%', 'fast')
  
}

Template.root.showDebugView = -> Session.get('showDebugView')