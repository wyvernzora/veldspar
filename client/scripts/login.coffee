###!
Veldspar.io - Meteor.js based EveMon alternative
Copyright © 2014 Denis Luchkin-Zhou
-------------------------------------------------------------------------------
login.coffee - This file contains interaction logic for login and signup
related processes.
###
Kernite = (this ? exports).Kernite

# LI: Login View
Meteor.startup ->
  ((view) ->
    # Attach Kernite functionality to the Meteor.js template
    Kernite.ui view
    # Multistate Components
    view.ms = email: new Veldspar.FormField '#li-email-group'
    # Login Form
    view.form = new Kernite.Form
      error: (errors) ->
        # Failed login attempt (incorrect password)
        if errors[0].type is 'server-error'
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
            form.error null, 'server-error', error.reason
          Session.set 'login.loading', no
      fields:
        '#li-email':
          name: 'email'
          validate: (value) ->
            if not /^\w+(\.\w+|)*@\w+\.\w+$/.test(value)
              return type: 'error', reason: 'Your <b>email address</b> doesn\'t look right!', critical:yes
          update: (result, reason) ->
            if result is 'ok'
              view.ms.email.state 'ok'
            else if view.ms.email.current isnt 'error'
              view.ms.email.state 'default'
          error: (error) ->
            view.ms.email.state 'error'

          success: (value) -> view.util.applyValidationStyle '#li-email-group', 'ok'
          next: '#li-password'
        '#li-password':
          name: 'password'
          success: ->
    # Meteor.js event handlers
    view.events view.form.attach
      'click #li-no-account': ->
        view.modal.show 'signup'
      'click #li-login': ->
        view.form.submit()
  )(Template.login)

# SU : Signup View
Meteor.startup ->
  ((view) ->
    # Attach Kernite functionality to the Meteor.js template
    Kernite.ui view
    # Signup Form
    view.form = new Kernite.Form
      error: (error) ->
        if error[0].type is 'server-error'
          Session.set 'signup.error', error[0].reason
          $('#su-error-box').effect 'pulsate', times: 2
          $('#su-email').focus().select()
        else
          for i,err of error.reverse()
            meta = view.form.fields[err.id]
            meta.error err if _.isFunction(meta.error)
      submit: (data) ->
        Session.set 'signup.loading', yes
        Accounts.createUser email:data.email, password:data.password, (error) ->
          if error
            view.form.error null, 'server-error', error.reason
          else
            $('#rt-modal-view').modal 'hide'
          Session.set 'signup.loading', no
      fields:
        '#su-email':
          name: 'email'
          next: '#su-password'
          validate: (value) ->
            if not /^\w+(\.\w+|)*@\w+\.\w+$/.test(value)
              return type: 'error', reason: 'Your <b>email address</b> doesn\'t look right!', critical:yes
          update: (result, reason) -> view.util.applyValidationStyle '#su-email-group', result
          error: (error) ->
            view.util.applyValidationStyle '#su-email-group', 'error'
            $('#su-email-group i').effect('pulsate', times:2)
            $('#su-email').focus().select()
          success: (value) -> view.util.applyValidationStyle '#su-email-group', null
        '#su-password':
          name: 'password'
          next: '#su-verify'
          validate: (value) ->
            strength = passwordStrength value
            if strength is 'weak' or strength is 'invalid'
              return type:'error', reason:'Your password is too weak!', critical:yes
            if strength is 'medium'
              return type:'warning', reason:'Your password may be vulnerable!', critical:no
            if strength is 'ok'
              return type:'ok', reason:'Your password is excellent!', critical:no
          update: (result, reason) -> view.util.applyValidationStyle '#su-password-group', result
          error: (error) ->
            view.util.applyValidationStyle '#su-password-group', 'error'
            $('#su-password-group i').effect('pulsate', times:2)
            $('#su-password').focus().select()
          success: (value) -> # Avoid form-wide callback
        '#su-verify':
          name: 'verify'
          validate: (value) ->
            password = $('#su-password').val()
            if value isnt password
              return type:'error', reason:'Password and verificatio do not match!'
          update: (result, reason) ->
            # Don't update if password is empty
            view.util.applyValidationStyle '#su-verify-group', result if $('#su-password').val() isnt ''
          error: (error) ->
            view.util.applyValidationStyle '#su-verify-group', 'error'
            $('#su-verify-group i').effect('pulsate', times:2)
            $('#su-verify').focus().select()
          success: (value) -> # Avoid form-wide callback
    # Meteor.js events
    view.events view.form.attach
      'click #su-submit': -> view.form.submit()
    # Meteor.js callback extension
    view.onRender ->
      Session.set 'signup.error', null
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
