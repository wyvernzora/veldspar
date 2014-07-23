/* Root Template */
(function (view) {
  view = Kernite.ui(view);

  var scrolling = false;

  view.events({
    'click #dbg-logout': function () {
      Meteor.logout();
    },
    'click #left #close': function () { view.left.close(); }
  });
  
  view.helpers({
    'sideviewIs': function (val) { return val === Session.get('sideview'); },
    'showLeftClose': function () { return Session.get('left.showCloseButton'); }
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