Veldspar = (this ? exports).Veldspar
Kernite = (this ? exports).Kernite

# User View
((view)->
  # Attach Kernite.ui functionality to view
  Kernite.ui view
  
  # Meteor.js events, helpers and callbacks
  view.events 
    'click #ur-add-char': ->
      view.left.open 'add-key'
    'click .char-item': ->
      if Session.get 'user.mode'
        sel = Session.get('user.selection') ? []
        id = this._id
        if (not _.find sel, (i) -> i is id)
          sel.push id
        else
          sel = _.reject sel, (i) -> i is id
        Session.set 'user.selection', sel
      
  
  
  
    'click #ur-delete-char': -> Session.set 'user.mode', 'delete'
    'click #ur-cancel-delete-char': -> 
      Session.set 'user.mode', null
      Session.set 'user.selection', null
    'click #ur-confirm-delete-char': ->
      sel = Session.get('user.selection') ? []
      for id in sel
        Veldspar.UserData.characters.remove _id:id
      Session.set 'user.mode', null
      Session.set 'user.selection', null
      
        
  view.helpers 
    'characters': ->
      return Veldspar.UserData.characters.find type: 'Character', {sort: name: 1}
    'corporations': ->
      return Veldspar.UserData.characters.find type: 'Corporation'
    'portrait': (type, size) ->
      return Kernite.Util.getPortrait type, @id, size
    'mode': (name) -> 
      Session.get('user.mode') is name
    'overlayStyles': ->
      # Delete Mode Selection
      sel = Session.get 'user.selection'
      id = this._id
      return 'hidden' if not _.find sel, (i) -> i is id
    'iconStyles': ->
      switch Session.get 'user.mode'
        when 'delete' then 'ion-ios7-close-outline'
      
    
  
  
  # Kernite.ui utility functions
    'characterAlert': ->
      if not Veldspar.UserData.characters.find(type: 'Character', {sort: name: 1}).count()
        return 'Unfortunately, we do not know any of your characters. Tell us about them by pressing <b>add</b>!'
      else if Session.get('user.mode') is 'delete'
        return 'Select characters you wish to delete by clicking them, then click <b>confirm</b>.'
  view.util 
    
  # Meteor.js callback extension
  view.onRender ->
    $('.char-grid').sortable()
    Session.set 'user.mode', null
    Session.set 'user.selection', null
  
  view
)(Template.user)

# Add Key
((view)->
  Kernite.ui view
  
  # Kernite Form
  view.form = new Kernite.Form
    '#ak-id':
      validate: (v) ->
        if (not /[0-9]+/.test v)
          return '<b>Key ID</b> must be a number!';
      error: '#ak-error-box'
      success: ->
        $('#ak-vcode').focus()
    '#ak-vcode':
      validate: (v) ->
        if (not /[A-Za-z0-9]{64}/.test v)
          return '<b>Verification Code</b> must be a 64-character string!'
      error: '#ak-error-box'
      success: ->
        if (Session.get 'addKey.loading')
          err = 'We are already talking to <b>CONCORD</b> about your recent request, please be patient.'
          $('#add-key .error-box').html(err).clearQueue().show().effect('pulsate', times: 2)
        
        Session.set 'addKey.loading', yes
        $('#ak-id, #ak-vcode').prop 'disabled', yes
        Meteor.call 'getApiKeyInfo', Number($('#ak-id').val()), $('#ak-vcode').val(), (err, result) ->
          if err
            $('#add-key .error-box').html(err.reason).clearQueue().show().effect('pulsate', times: 2)
            Session.set 'addKey.loading', no
            $('#ak-id, #ak-vcode').prop 'disabled', no
          else
            Session.set 'addKey.apiKeyInfo', result
        
  
  # Meteor.js events
  view.events
    'click #ak-cancel': -> view.left.close()
    'click #ak-submit': -> view.form.validate null
    'keydown #ak-id': (e) -> view.form.validate '#ak-id' if e.keyCode is 13
    'keydown #ak-vcode': (e) -> view.form.validate null if e.keyCode is 13
    'click .char-item': ->
      info = Session.get 'addKey.apiKeyInfo'
      id = @id
      char = _.find info.characters, (c) -> c.id is id
      char.excluded = not char.excluded
      Session.set 'addKey.apiKeyInfo', info
    'click #ak-add': ->
      info = Session.get 'addKey.apiKeyInfo'
      chars = _(info.characters).filter((i) -> not i.excluded).map((i) -> _.omit i, 'excluded');
      info.characters = undefined
      
      _.each chars, (i) ->
        i.apiKey = info
        i.owner = Meteor.userId()
        i.type = if info.type is 'Account' or info.type is 'Character' then 'Character' else 'Corporation'
        existing = Veldspar.UserData.characters.findOne 'id': i.id, 'apiKey.id': info.id, {fields: {_id: 1}}
        if existing
          Veldspar.UserData.characters.update _id:existing._id, i
        else
          Veldspar.UserData.characters.insert i
      
      view.left.close()
      
  view.helpers
    'loading': -> Session.get 'addKey.loading'
    'apiKeyInfo': -> Session.get 'addKey.apiKeyInfo'    
    'portrait': (type, size) -> Kernite.Util.getPortrait type, @id, size
    'expirationMsg': ->
      key = Session.get 'addKey.apiKeyInfo'
      if key
        return 'never expires' if not key.expires
        return 'has already expired' if key.expires < Date.now()
        return 'expires on ' + key.expires.toDateString()
    
  
  # Meteor.js callback extension
    'selectionStyles': ->
      info = Session.get 'addKey.apiKeyInfo'
      id = this.id
      char = _.find info.characters, (c) -> c.id is id
      return 'hidden' if not char.excluded
  view.onRender ->
    Session.set 'addKey.loading', no
    Session.set 'addKey.apiKeyInfo', null
    Session.set 'addKey.selection', null
    $('#ak-id').focus()
  
  view
)(Template.addKey)