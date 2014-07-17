/*
# Veldspar EVE Online API Client
# login.js - Interaction logic for views/login.html
# Copyright © Denis Luchkin-Zhou
*/
(function (view) {

  /* Attach Veldspar.view functionality to Meteor template */
  view = Veldspar.UI.init(view);
  /* Event Handling */
  view.events({
    'keydown .main #uname': view.forward('.main #pwd', function () {
      return view.util.validateLoginEmail();
    }),
    'keydown .main #pwd': function (e) {
      if (e.keyCode === 13) {
        view.util.login();
      }
    },
    'click .main #forgot': function () {
      alert('WIP');
    },
    'click .main #submit': function () {
      view.util.login();
    },
    'click .main #signup': function () {
      view.Sidebar.resize('left-scale', '30%', function () {
        $('#email', view.side()).focus();
      });
    },
    'keydown .sidebar #email': view.forward('.sidebar #pwd1', function () {
      return view.util.validateEmail();
    }),
    'keydown .sidebar #pwd1': view.forward('.sidebar #pwd2'),
    'keydown .sidebar #pwd2': function (e) {
      if (e.keyCode === 13 && view.util.validatePassword(true)) {
        view.util.signup();
      }
    },
    'click .sidebar .cancel': function () {
      view.Sidebar.resize('left-scale', '0', view.util.resetSidebar);
    },
    'click .sidebar .ui-button-submit': function () {
      view.util.signup();
    }
  });
  /* Template Helper Functions */
  view.helpers({
    'showLoading': function () {
      return Session.get('signup_ShowLoading');
    }
  });
  /* UI Utility Functions */
  view.util({
    'login': function () {
      var $uname = $('#uname', view.main()).removeClass('ui-textbox-error'),
        $pwd = $('#pwd', view.main()).removeClass('ui-textbox-error'),
        uname = $uname.val(),
        pwd = $pwd.val();

      if (view.util.validateLoginEmail()) {
        Meteor.loginWithPassword({
          email: uname
        }, pwd, function (err) {
          if (err) {
            var $box = $('#shaky', view.main());
            $('#pwd', view.main()).val('');
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
            $('#forgot', view.main()).show('fade');
          }
        });
      }
    },
    'signup': function () {
      if (view.util.validateEmail() && view.util.validatePassword(true)) {
        Session.set('signup_ShowLoading', true);
        view.Step.next(view.side());
        Accounts.createUser({
          email: $('#email', view.side()).val(),
          password: $('#pwd1', view.side()).val()
        }, function (err) {
          if (err) {
            view.showError(view.side(), err.reason);
            view.Step.prev(view.side(), function () {
              Session.set('signup_ShowLoading', false);
              $('#email', view.side()).focus();
            });
          }
        });
      }
    },
    'resetSidebar': function () {
      $('.ui-textbox', view.side()).val('').removeClass('ui-textbox-error');
      view.Step.reset(view.side());
      view.showError(view.side(), null);
    },
    'validateEmail': function () {
      var $email = $('#email', view.side()).removeClass('ui-textbox-error');
      if (!view.util.isEmailAddress($email.val())) {
        view.showError(view.side(), 'Your <b class="accented">email address</b> doesn\'t look right.');
        $email.addClass('ui-textbox-error');
        return false;
      }
      view.showError(view.side(), null);
      return true;
    },
    'validatePassword': function (match) {
      var $pwd1 = $('#pwd1', view.side()).removeClass('ui-textbox-error'),
        $pwd2 = $('#pwd2', view.side()).removeClass('ui-textbox-error'),
        pwd1 = $pwd1.val(),
        pwd2 = $pwd2.val();

      /* Validate for length */
      if (pwd1.length < 8) {
        view.showError(view.side(), 'Your <b class="accented">password</b> should be at least 8 characters long!');
        $pwd1.addClass('ui-textbox-error').val('').focus();
        return false;
      }

      /* Validate verification */
      if (match && pwd1 !== pwd2) {
        view.showError(view.side(), 'Your <b class="accented">password</b> and <b class="accented">verification</b> do not match!');
        $pwd1.addClass('ui-textbox-error').val('').focus();
        $pwd2.addClass('ui-textbox-error').val('');
        return false;
      }

      view.showError(view.side(), null);
      return true;
    },
    'validateLoginEmail': function () {
      var $uname = $('#uname', view.main()).removeClass('ui-textbox-error'),
        uname = $uname.val();

      if (!view.util.isEmailAddress(uname)) {
        view.showError(view.main(), 'Your <b class="accented">email address</b> doesn\'t look right.');
        $uname.addClass('ui-textbox-error').focus();
        return false;
      }

      view.showError(view.main(), null);
      return true;
    }
  });
  /* Rendered Callback */
  view.rendered = function () {
    view.Step.init(view.side());
    $('#uname', view.main()).focus()
  }
  
})(Template.login);