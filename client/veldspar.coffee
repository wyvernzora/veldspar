Template.hello.events {
  'click input': ->
    Meteor.call 'test', (err, result) ->
      result = err if err
      node = new PrettyJSON.view.Node { data: result, el: $('#result') }
      console.log JSON.stringify result
}