Veldspar = (this ? exports).Veldspar
Kernite = (this ? exports).Kernite

# LI: Login View
((view) ->
  Kernite.ui view
  
  # Login Form
  ###
  view.form = new Kernite.Form 
    '#li-email':
      'validate': (v) ->
        if not Kernite.Util.isEmailAddress v
          return 'Your <b>email address</b> doesn\'t look right.'
      'error': '#li-error-box'
      'success': (v) ->
        $('#li-email').removeClass('error');
        $('#login .error-box').hide('fade');
        $('#li-password').focus();
    '#li-password':
      'validate': (v) ->
        if v is '' 
          return '<b>Empty password?</b> Are you sure?!'
      'error': '#li-error-box'
      'success': (v) ->
        email = $('#li-email').val()
        Session.set 'login.loading', yes  # Start loading animation
        Meteor.loginWithPassword email:email, v, (err) ->
          Session.set 'login.loading', no # Stop loading animation
          if err
            $box = $ '#li-shaky'
            $pwd = $ '#li-password'
            $pwd.val ''
            $box.animate(left:20, 80)
              .animate(left:-20, 80)
              .animate(left:20, 80)
              .animate(left:0, 80)
            $('#li-forgot').show 'fade'
  
  
  # Meteor.js events
  view.events 
    'keydown #li-email': (e) -> view.form.validate '#li-email' if e.keyCode is 13
    'keydown #li-password': (e) -> view.form.validate null if e.keyCode is 13
    'click #li-login.btn': -> view.form.validate null
    'click #li-signup.btn': -> view.left.open 'signup'
    'click #li-powered-by': -> view.left.open 'credits'
    'click #li-dev-mode': ->
      $('html').toggleClass 'beta'
      if $('html').hasClass 'beta'
        $('#li-dev-mode').addClass 'danger'
      else
        $('#li-dev-mode').removeClass 'danger'
      ###
  # Meteor.js helpers
  view.helpers
    'loading': -> Session.get 'login.loading'
  
  # Callbacks
  view.onRender ->
    $('#li-email').focus()
    Session.set 'login.loading', no
    
  view.onRender ->
    if $('html').hasClass 'beta'
      $('#li-dev-mode').addClass 'danger'
    else
      $('#li-dev-mode').removeClass 'danger'
  
  view
)(Template.login)

# SU: Signup View
((view) ->
  Kernite.ui view
  
  # Signup Form
  view.form = new Kernite.Form
    '#su-email':
      validate: (v) ->
        if not Kernite.Util.isEmailAddress v
          return 'Your <b>email address</b> doesn\'t look right.'
      error: '#su-error-box'
      success: ->
        suppressPasswordQlty = yes
        $('#su-password').focus()
    '#su-password':
      validate: (v) ->
        quality = Kernite.Util.passwordStrength v
        if quality is 'invalid' or quality is 'weak'
          return 'invalid password'
      error: (e) ->
        view.util.updatePasswordQuality();
        $('#su-password').addClass 'error' ;
        $('#su-password-quality').clearQueue().effect 'pulsate', times: 2
      success: ->
        $('#su-password, #su-verify').removeClass 'error'
        $('#su-password-quality').hide 'fade'
        $('#su-verify').focus()
    '#su-verify':
      validate: (v) ->
        password = $('#su-password').val()
        if password isnt v
          return 'Your <b class="accent">password</b> and <b class="accent">verification</b> don\'t match!'
      error: (e) ->
        $('#su-password, #su-verify').addClass('error').val ''
        $('#su-password-quality').html(e).clearQueue().effect 'pulsate', times: 2
        suppressPasswordQlty = yes
        $('#su-password').focus()
      success: (v) ->
        $('#su-password, #su-verify').removeClass 'error'
        $('#su-password-quality').hide 'fade'
        $('#signup .textbox').prop 'disabled', yes
        Session.set 'signup.loading', yes  
        Accounts.createUser email: $('#su-email').val(), password: $('#su-password').val(), (err) ->
          if err
            $('#signup .textbox').prop 'disabled', no
            $('#su-cancel.button').show 'fade', 'fast'
            $('#signup .error-box').html(err.reason).show().clearQueue().effect 'pulsate', times: 2
            Session.set 'signup.loading', no
          else
            view.left.close()
          
  # Meteor.js events
  view.events 
    'keydown #su-email': (e) -> view.form.validate '#su-email' if e.keyCode is 13
    'keydown #su-password': (e) -> view.form.validate '#su-password' if e.keyCode is 13
    'keyup #su-password': -> view.util.updatePasswordQuality()
    'keydown #su-verify': (e) -> view.form.validate null if e.keyCode is 13
    'click #su-submit.btn': -> view.form.validate null
    'click #su-cancel.btn': -> view.left.close()
  
  # Meteor.js helpers
  view.helpers
    'loading': -> Session.get 'signup.loading'
  
  # Kernite.UI utilities
  view.util
    'updatePasswordQuality': ->
      quality = Kernite.Util.passwordStrength $('#su-password').val()
      if suppressPasswordQlty
        suppressPasswordQlty = no
        return
      message = switch quality
        when 'ok' then 'This password is <span class="pwd-good">excellent.</span><br>Great job, casuleer!'
        when 'medium' then 'This password is <span class="pwd-weak">not bad.</span><br>Maybe add a symbol or two?'
        when 'weak' then 'This password is <span class="pwd-invalid">too weak.</span><br>Try adding some capital letters and numbers.'
        when 'invalid' then 'This password is <span class="pwd-invalid">too short.</span><br>Let\'s start with some digits and letters.'        
      $('#su-password-quality').html(message).show 'fade'

  # Kernite.UI callback extensions
  view.onRender ->
    $('#su-email').focus()
      
  view
)(Template.signup)