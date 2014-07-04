# UI Events
Template.login.events {
  
  'keydown #login-username': (event) ->
    if event.keyCode is 13
      $('#login-password').focus()
  
  'keydown #login-password': (event) ->
    if event.keyCode is 13
      Template.login.loginSubmit()
  
  'click #login-forgot': (event) ->
    alert 'Not implemented yet! Please check back later.'
  
  'click #login-submit': (event) ->
    Template.login.loginSubmit()
}

# UI Callbacks
Template.login.rendered = ->
  this.find('#login-view #login-username').focus()
  
# UI Methods
Template.login.loginFailed = ->
  box = $('#login-view #login-wrapper')
  speed = 80;
  $('#login-view #login-password').val('').focus()
  box.animate({left: 10}, speed)
    .animate({left: -10}, speed)
    .animate({left: 10}, speed)
    .animate({left: 0}, speed)
  $('#login-view #login-forgot').show()

Template.login.loginSubmit = ->
  username = $('#login-username').removeClass('textbox-invalid').val()
  password = $('#login-password').removeClass('textbox-invalid').val()
  
  if username is ''
    Template.login.showErrMessage 'Capsuleer, you do have an email don\'t you?'
    $('#login-username').addClass('textbox-invalid').focus()
    return
  else
    Template.login.showErrMessage undefined
  
  Meteor.loginWithPassword email: username, password, (err) ->
    if err
      Template.login.loginFailed()
      
Template.login.showErrMessage = (message) ->
  motd = $('#login-view .motd')
  toast = $('#login-view #login-err')
  if message
    toast.html message
    motd.hide()
    toast.show()
  else
    motd.show()
    toast.hide()
