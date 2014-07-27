/* Root Template */
(function (view) {
  view = Kernite.ui(view);

  var scrolling = false;

  view.events({
    'click #dbg-logout': function () {
      Meteor.logout();
    },
    
  });
  
  view.helpers({
    'sideviewIs': function (val) { return val === Session.get('sideview'); }
  });
  
  view.onRender(function () {
    $('#main-stage').scroll(function () {
      if ($('#main-stage').scrollTop() > 5) {
        if (scrolling) {
          return;
        }
        scrolling = true;
        $('header').addClass('scroll');
      } else {
        $('header').removeClass('scroll');
        scrolling = false;
      }
    });
    /* This event has to be attached via jQuery to work on iOS */
    $('#gaia #overlay').click(function () {
      view.left.close();
    });
    $('#left #close').click(function () {
      view.left.close();
    });
  });

  return view;
})(Template.root);

/* Header Template */
(function (view) {

  view = Kernite.ui(view);

  view.helpers({

  });

  return view;
})(Template.header);