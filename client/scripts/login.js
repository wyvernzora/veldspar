/* Login View */
(function (view) {
  view = Kernite.ui(view);

  view.events({
    'keydown #li-email': view.util.forward('#li-password', function () {
      return view.util.validateEmail();
    }),
    'keydown #li-password': view.util.forward(function () {
      view.util.login();
    }),
    'click #li-signup.button': function () {
      view.left.open('signup');
    },
    'click #li-login.button': function () {
      view.util.login();
    },
    'click #li-powered-by': function () {
      view.left.open('credits');
    },
    'click #li-dev-mode': function () {
      $('html').toggleClass('beta');
      if ($('html').hasClass('beta')) {
        $('#li-dev-mode').addClass('danger');
      } else {
        $('#li-dev-mode').removeClass('danger');
      }
    }
  });

  view.helpers({
    'loading': function () {
      return Session.get('login.loading');
    }
  });

  view.util({
    'validateEmail': function () {
      var $email = $('#li-email').removeClass('error'),
        $err = $('#login .error-box'),
        email = $email.val();

      if (!view.util.isEmailAddress(email)) {
        $err.html('Your <b class="accent">email address</b> doesn\'t look right.')
          .show().clearQueue().effect('pulsate', {
            times: 2
          });
        $email.addClass('error').focus();
        return false;
      }

      $err.hide('fade');
      return true;
    },
    'login': function () {
      var $email = $('#li-email').removeClass('error'),
        $psswd = $('#li-password').removeClass('error'),
        email = $email.val(),
        psswd = $psswd.val();

      if (view.util.validateEmail()) {
        Session.set('login.loading', true);
        Meteor.loginWithPassword({
          email: email
        }, psswd, function (err) {
          Session.set('login.loading', false);
          if (err) {
            var $box = $('#li-shaky');
            $('#li-password').val('');
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
            $('#li-forgot').show('fade');
          }
        });
      }
    }
  });

  view.onRender(function () {
    Session.set('login.loading', false);
    $('#li-email').focus();
  });

  view.onRender(function () {
          if ($('html').hasClass('beta')) {
        $('#li-dev-mode').addClass('danger');
      } else {
        $('#li-dev-mode').removeClass('danger');
      }
  });
  
  return view;
})(Template.login);

/* Signup View */
(function (view) {
  Kernite.ui(view);

  /* Private utility functions */
  var passwordStrength = function (str) {
    var strongRegex = new RegExp("^(?=.{8,})(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*\\W).*$", "g");
    var mediumRegex = new RegExp("^(?=.{7,})(((?=.*[A-Z])(?=.*[a-z]))|((?=.*[A-Z])(?=.*[0-9]))|((?=.*[a-z])(?=.*[0-9]))).*$", "g");
    var enoughRegex = new RegExp("(?=.{6,}).*", "g");
    if (false == enoughRegex.test(str)) {
      return 'invalid';
    } else if (strongRegex.test(str)) {
      return 'ok';
    } else if (mediumRegex.test(str)) {
      return 'medium';
    } else {
      return 'weak';
    }
  };

  /* Misc junk */
  var suppressPasswordQlty = false; // Suppresses password validation once when true

  /* Meteor.js stuff */
  view.events({
    'click #su-cancel.button': function () {
      //$('#li-email').focus();
      view.left.close();
    },
    'click #su-submit.button': function () {
      view.util.submit();
    },
    'keyup #su-password': function () {
      view.util.updatePasswordQuality();
    },
    'keydown #su-password': view.util.forward('#su-verify', function () {
      return view.util.validate.password();
    }),
    'keydown #su-email': view.util.forward('#su-password', function () {
      return view.util.validate.email();
    }),
    'keydown #su-verify': view.util.forward(function () {
      view.util.submit();
    })
  });

  view.helpers({
    'loading': function () {
      return Session.get('signup.loading');
    }
  });

  view.util({
    'reset': function () {
      $('#signup .textbox').removeAttr('disabled');
      $('#su-cancel.button').show();
      $('#signup .error-box').hide();
      $('#su-email, #su-password, #su-verify').removeClass('error').val('');
      $('#su-password-quality').hide();
      Session.set('signup.loading', false);
    },
    'validate': {
      'email': function () {
        var email = $('#su-email').val();
        if (view.util.isEmailAddress(email)) {
          $('#su-email').removeClass('error');
          $('#signup .error-box').hide('fade');
          suppressPasswordQlty = true;
          return true;
        } else {
          $('#su-email').addClass('error').focus();
          $('#signup .error-box').html('Your <b class="accent">email address</b> doesn\'t look right.').show()
            .clearQueue().effect('pulsate', {
              times: 2
            });
          return false;
        }
      },
      'password': function () {
        var password = $('#su-password').val(),
          quality = passwordStrength(password);
        if (quality === 'ok' || quality === 'medium') {
          $('#su-password, #su-verify').removeClass('error');
          $('#su-password-quality').hide('fade');
          return true;
        }
        view.util.updatePasswordQuality();
        $('#su-password').addClass('error');
        $('#su-password-quality').clearQueue().effect('pulsate', {
          times: 2
        });
        return false;
      },
      'verify': function () {
        var password = $('#su-password').val(),
          verify = $('#su-verify').val();

        // Check if password and verification match
        if (password !== verify) {
          suppressPasswordQlty = true;
          $('#su-password').focus();
          $('#su-password, #su-verify').addClass('error').val('');
          $('#su-password-quality').html('Your <b class="accent">password</b> and <b class="accent">verification</b> don\'t match!')
            .clearQueue().effect('pulsate', {
              times: 2
            });
          return false;
        }

        $('#su-password, #su-verify').removeClass('error');
        $('#su-password-quality').hide('fade');
        return true;
      }
    },
    'updatePasswordQuality': function () {
      var password = $('#su-password').val(),
        quality = passwordStrength(password);
      if (suppressPasswordQlty) {
        suppressPasswordQlty = false;
        return;
      }
      switch (quality) {
      case 'ok':
        $('#su-password-quality').html('This password is <span class="pwd-good">excellent.</span><br>Great job, casuleer!').show('fade');
        break;
      case 'medium':
        $('#su-password-quality').html('This password is <span class="pwd-weak">not bad.</span><br>Maybe add a symbol or two?').show('fade');
        break;
      case 'weak':
        $('#su-password-quality').html('This password is <span class="pwd-invalid">too weak.</span><br>Try adding some capital letters and numbers.').show('fade');
        break;
      case 'invalid':
        $('#su-password-quality').html('This password is <span class="pwd-invalid">too short.</span><br>Let\'s start with some digits and letters.').show('fade');
        break;
      }
    },
    'submit': function () {
      var email = $('#su-email').val(),
        psswd = $('#su-password').val();

      if (view.util.validate.email() &&
        view.util.validate.password() &&
        view.util.validate.verify()) {
        /* Switch to the 'loading' UI state */
        $('#su-cancel.button').hide('fade');
        $('#signup .textbox').attr('disabled', 'disabled');
        Session.set('signup.loading', true);
        /* Create the account */
        Accounts.createUser({
          email: email,
          password: psswd
        }, function (err) {
          /* Check for errors */
          if (err) {
            $('#signup .textbox').removeAttr('disabled');
            $('#su-cancel.button').show('fade', 'fast');
            $('#signup .error-box').html(err.reason).show()
              .clearQueue().effect('pulsate', {
                times: 2
              });
            Session.set('signup.loading', false);
          } else {
            view.left.close();
          }
        });
      }
    }
  });

  view.onRender(function () {
    $('#su-email').focus();
  });

  return view;
})(Template.signup);