Template.hello.events({
  'click input': function () {

    Meteor.call("test", function (err, result) {
      
      if (err) result = err;
      
      var node = new PrettyJSON.view.Node({
        el: $('#result'),
        data: result
      });
      
    });

  }
});