var view = Template.login;

view.events({
  'click #login': function () {
    if (Components.Sidebar.isOpen){
      Components.Sidebar.hide('left-scale');
    }
  },
  'keydown #login #uname': function (e) {
    if (e.keyCode === 13) {
      $('#login #pwd').focus();
    }
  },
  'keydown #login #pwd': function (e) {
    if (e.keyCode === 13) {
      view.submit();
    }
  },
  'click #login #forgot': function () {
    alert('WIP');
  },
  'click #login #submit': function () {
    view.submit();
  },
  'click #login #signup': function () {
    Components.Sidebar.show('30%', 'left-scale');
  }
});

view.helpers({

});

view.rendered = function () {
  $('#login #uname').focus()
}

view.loginFailed = function () {
  var $box = $('#login #shaky');
  $('#login #pwd').val('');
  var speed = 80;
  var magnitude = 20;
  $box.animate({
    left: magnitude
  }, speed)
    .animate({
      left: -magnitude
    }, speed)
    .animate({
      left: magnitude
    }, speed)
    .animate({
      left: 0
    }, speed);
  $('#login #forgot').show('fade');
}

view.submit = function () {
  var $uname = $('#login #uname').removeClass('ui-textbox-error'),
    $pwd = $('#login #pwd').removeClass('ui-textbox-error');
  var uname = $uname.val(),
    pwd = $pwd.val();

  if (uname === '') {
    Components.ErrorBox.show('#login', 'Capsuleer, don\'t you have an email?');
    $uname.addClass('ui-textbox-error').focus();
    return;
  } else {
    Components.ErrorBox.show('#login', null);
  }

  Meteor.loginWithPassword({
    email: uname
  }, pwd, function (err) {
    if (err) {
      view.loginFailed();
    }
  });


}