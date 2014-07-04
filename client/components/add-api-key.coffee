Template.addApiKey.events {
  'click #add-api-key .cancel': ->
    Template.addApiKey.hideSidebar()
    
  'click #add-api-next': ->
    Template.addApiKey.submitKey()
    
  'keydown #add-api-id': (ev) ->
    if ev.keyCode is 13
      $('#add-api-vcode').focus()
      
  'keydown #add-api-vcode': (ev) ->
    if ev.keyCode is 13
      Template.addApiKey.submitKey()
      
  'click .char-list-item': (ev) ->
    key = Session.get 'addApiKey_Adding'
    id = this.id
    char = _.find key.characters, (i) ->
      return i.id is id
    char.selected = not char.selected
    Session.set 'addApiKey_Adding', key
    
  'click #add-api-add': (ev) ->
    console.log 'submit'
    Template.addApiKey.addCharacters()
    Template.addApiKey.hideSidebar()
}

Template.addApiKey.showSidebar = ->
  $wrapper = $('#main-wrapper')
  $wrapper.animate 'margin-left': '25%', 'margin-right': '-25%', 'slow', -> 
    Session.set 'addApiKey_ShowLoading', yes
    $('#add-api-key #add-api-id').focus()              

Template.addApiKey.hideSidebar = ->
  # Hide the sidebar itself
  $wrapper = $('#main-wrapper')
  $wrapper.animate 'margin-left': '0', 'margin-right': '0', 'slow', ->
    # Clear text field values
    $('#add-api-id').val('')
    $('#add-api-vcode').val('')
    Session.set 'addApiKey_ShowLoading', no
    # Reset steps
    Template.addApiKey.resetSteps()
  
Template.addApiKey.resetSteps = ->
  $('#add-api-key #step-one').removeAttr 'style'
  $('#add-api-key #step-two').removeAttr 'style'
  
Template.addApiKey.nextStep = ->
  $('#add-api-key .step').animate('left': '-=100%', 'fast')
  
Template.addApiKey.prevStep = ->
  $('#add-api-key .step').animate('left': '+=100%', 'fast')
  

  
Template.addApiKey.submitKey = ->
  # Get input values
  id = Number($('#add-api-id').removeClass('textbox-invalid').val())
  code = $('#add-api-vcode').removeClass('textbox-invalid').val()
  # Verify input
  if _.isNaN(id) or id is 0
    $('#add-api-key #error').html('<span class="accented">API Key ID</span> should be a number!').show()
    $('#add-api-id').addClass('textbox-invalid').focus()
    return;
  if code.length isnt 64
    $('#add-api-key #error').html('<span class="accented">Verification Code</span> should be 64-character string!').show()
    $('#add-api-vcode').addClass('textbox-invalid').focus()
    return;
  $('#add-api-key #error').hide()
  Session.set 'addApiKey_Adding', null
  Meteor.call 'getApiKeyInfo', id, code, (err, result) ->
    if err
      alert(err.reason)
      Session.set 'veldspar_error', err
    else
      Session.set 'addApiKey_Adding', result
  Template.addApiKey.nextStep()

Template.addApiKey.addCharacters = ->
  key = Session.get 'addApiKey_Adding'
  key.owner = Meteor.userId()
  key.characters = _.map _.filter(key.characters, (i)->i.selected), (o)->
    _.omit o, 'selected'
  if key.characters.length isnt 0
    existing = Veldspar.UserData.apiKeys.findOne({id: key.id}, {fields: {_id: 1}})
    if existing
      Veldspar.UserData.apiKeys.update {_id: existing._id}, key
    else
      Veldspar.UserData.apiKeys.insert key
  
  
Template.addApiKey.expirationMessage = ->
  key = Session.get 'addApiKey_Adding'
  if key
    if not key.expires
      return 'never expires'
    if key.expires < (new Date())
      return 'has already expired'
    else
      return 'expires on ' + key.expires.toDateString()
  
Template.addApiKey.characters = ->
  key = Session.get 'addApiKey_Adding'
  return key.characters
Template.addApiKey.apiKeyInfo = ->
  Session.get 'addApiKey_Adding'
  
Template.addApiKey.portraitUrl = ->
  return Veldspar.Config.imageHost + '/' + this.id + '_64.jpg'
Template.addApiKey.allianceName = ->
  if this.alliance.name isnt ''
    return this.alliance.name
  else
    return 'No Alliance'
Template.addApiKey.selIconClass = ->
  if this.selected
    return 'ion-ios7-checkmark-outline char-sel'
  else
    return 'ion-ios7-circle-outline'
Template.addApiKey.showLoading = ->
  return Session.get 'addApiKey_ShowLoading'