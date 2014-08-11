###
Veldspar.io - Meteor.js based EveMon alternative
Copyright © 2014 Denis Luchkin-Zhou
-------------------------------------------------------------------------------
login.coffee - This file contains interaction logic for login and signup
related processes.
###
Kernite = (this ? exports).Kernite

# LI: Login View
((view) ->
  Kernite.ui view  # Attach Kernite functionality to the Meteor.js template

  # Login Form
  view.form = new Kernite.Form
    error: (errors) ->
      # Failed login attempt (incorrect password)
      if errors[0].type is 'authentication-failure'
        $('#li-login-form .form-group')
          .animate(left:20, 80)
          .animate(left:-20, 80)
          .animate(left:20, 80)
          .animate(left:0, 80)
        $('#li-forgot-password').show 'fade'
        $('#li-password').focus().select()
      # ...otherwise handle the first error
      else if errors[0].id
        meta = @fields[errors[0].id]
        meta.error errors[0] if _.isFunction(meta.error)
    submit: (data) ->
      Session.set 'login.loading', yes
      form = @
      Meteor.loginWithPassword email:data.email, data.password, (error) ->
        if error
          form.error null, 'authentication-failure', error.reason
        Session.set 'login.loading', no
    fields:
      '#li-email':
        name: 'email'
        validate: (value) ->
          if not /^\w+(\.\w+|)*@\w+\.\w+$/.test(value)
            return type: 'error', reason: 'Your <b>email address</b> doesn\'t look right!'
          return null;
        update: (result, reason) ->
          $input = $('#li-email-group');
          if result is 'ok'
            $input.removeClass('has-error').addClass 'has-success has-feedback'
          else if (not $input.hasClass('has-error'))
            $input.removeClass 'has-success has-error has-feedback'
        error: (error) ->
          $('#li-email-group').removeClass('has-success').addClass('has-feedback has-error')
          $('#li-email-group i').effect('pulsate', times:2)
          $('#li-email').focus().select()
        success: (value) -> $('#li-email-group').removeClass('has-error').addClass('has-feedback has-success')
        next: '#li-password'
      '#li-password':
        name: 'password'
        success: ->

  view.events view.form.attach
    'click #li-no-account': ->
      Session.set 'modal', 'signup'
      $('#rt-modal-view').modal 'show'

)(Template.login)

# SU : Signup View
((view) ->

  #Meteor.js events
  view.events
    'keyup #su-email': ->
      val = $('#su-email').val()
      if /^\w+(\.\w+|)*@\w+\.\w+$/.test(val)
        $('#su-email-group').addClass 'has-success has-feedback'
      else
        $('#su-email-group').removeClass 'has-success has-feedback'
    'keyup #su-password': ->
      val = $('#su-password').val()
      strength = passwordStrength(val)
      $('#su-password-group')
        .removeClass('has-success has-warning has-error has-feedback')
        .addClass switch strength
          when 'ok' then 'has-success has-feedback'
          when 'medium' then 'has-warning has-feedback'
          else 'has-error has-feedback'
    'keyup #su-verify': ->
      password = $('#su-password').val()
      verify = $('#su-verify').val()

      $('#su-verify-group')
        .removeClass('has-success has-warning has-error has-feedback')
        .addClass if password is verify then 'has-success has-feedback' else 'has-error has-feedback'

  # Utilities
  passwordStrength = (str) ->
    s = new RegExp '^(?=.{8,})(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*\\W).*$', 'g'
    m = new RegExp '^(?=.{7,})(((?=.*[A-Z])(?=.*[a-z]))|((?=.*[A-Z])(?=.*[0-9]))|((?=.*[a-z])(?=.*[0-9]))).*$', 'g'
    e = new RegExp '(?=.{6,}).*', 'g'
    return 'invalid' if not e.test str
    return 'ok' if s.test str
    return 'medium' if m.test str
    return 'weak'


)(Template.signup)
