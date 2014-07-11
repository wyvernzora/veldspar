var view = $.extend(Template.login, new Veldspar.UI.view(Template.login));

view.events({
  'keydown #login #uname': view.forward('#login #pwd'),
  'keydown #login #pwd': function (e) {
    if (e.keyCode === 13) {
      view.login();
    }
  },
  'click #login #forgot': function () {
    alert('WIP');
  },
  'click #login #submit': function () {
    view.login();
  },
  'click #login input#signup': function () {
    view.Sidebar.resize('left-scale', '30%', function () { $('#signup #email').focus(); } );
  },
  'keydown #signup #email': view.forward('#signup #pwd1', function () { return view.validateEmail(); }),
  'keydown #signup #pwd1': view.forward('#signup #pwd2'),
  'keydown #signup #pwd2': function (e) {
    if (e.keyCode === 13 && view.validatePassword(true)) {
      view.signup();
    }
  },
  'click #signup .cancel': function () {
    view.Sidebar.resize('left-scale', '0', view.resetSidebar);
  },
  'click #signup .ui-button-submit': function () {
    view.signup();
  }
});

view.helpers({
  'showLoading': function () {
    return Session.get('signup_ShowLoading');
  }
});

view.rendered = function () {
  $('#login #uname').focus()
}

view.login = function () {
  var $uname = $('#login #uname').removeClass('ui-textbox-error'),
    $pwd = $('#login #pwd').removeClass('ui-textbox-error');
  
  var uname = $uname.val(),
    pwd = $pwd.val();

  if (uname === '') {
    this.showError('#login .main', 'Capsuleer, don\'t you have an email?');
    $uname.addClass('ui-textbox-error').focus();
    return;
  } else {
    this.showError('#login', null);
  }

  Meteor.loginWithPassword({
    email: uname
  }, pwd, function (err) {
    if (err) {
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
  });


}

view.resetSidebar = function () {
  $('#signup #email').val('').removeClass('ui-textbox-error');
  $('#signup #pwd1').val('').removeClass('ui-textbox-error');
  $('#signup #pwd2').val('').removeClass('ui-textbox-error');
  $('#signup .step').removeAttr('style');
  view.showError('#signup', null);
};

view.signup = function () {
  if (view.validateEmail() && view.validatePassword(true)) {
    Session.set('signup_ShowLoading', true);
    $('#signup .step').animate({
        'left': '-=100%'
      }, 'fast');
    Accounts.createUser({email: $('#signup #email').val(), password: $('#signup #pwd1').val() }, function (err) {
      if (err) {
        view.showError('#signup', err.reason);
        $('#signup .step').animate({
          'left': '+=100%'
        }, 'fast', function () {
          Session.set('signup_ShowLoading', false);
          $('#signup #email').focus();
        });
      }
    });
  }
}

/* Utility methods */
view.validateEmail = function () {
  var $email = $('#signup #email').removeClass('ui-textbox-error');
  if (!Components.Util.isEmailAddress($email.val())) {
    this.showError('#signup', 'Your <b class="accented">email address</b> doesn\'t look right.');
    $email.addClass('ui-textbox-error');
    return false;
  }
  this.showError('#signup', null);
  return true;
};

view.validatePassword = function (match) {
  var $pwd1 = $('#signup #pwd1').removeClass('ui-textbox-error'),
      $pwd2 = $('#signup #pwd2').removeClass('ui-textbox-error'),
      pwd1 = $pwd1.val(),
      pwd2 = $pwd2.val();
  
  /* Validate for length */
  if (pwd1.length < 8) {
    this.showError('#signup', 'Your <b class="accented">password</b> should be at least 8 characters long!');
    $pwd1.addClass('ui-textbox-error').val('').focus();
    return false;
  }
  
  /* Validate verification */
  if (match && pwd1 !== pwd2) {
    this.showError('#signup', 'Your <b class="accented">password</b> and <b class="accented">verification</b> do not match!');
    $pwd1.addClass('ui-textbox-error').val('').focus();
    $pwd2.addClass('ui-textbox-error').val('');
    return false;
  }
  
  this.showError('#signup', null);
  return true;
}
