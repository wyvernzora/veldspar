Veldspar = (this ? exports).Veldspar
Kernite = (this ? exports).Kernite

# UR: User View
Meteor.startup ->
  ((view) ->
    Kernite.ui view

    view.refresh = new Veldspar.Refresh '#ur-refresh', 'data.updateUserView'

    view.events
      # Replace broken portraits with generic ones
      'error img': (e) ->
        $(e.currentTarget).attr 'src', '/character.svg'
      # Toolbar actions
      'click #ur-add-key': ->
        view.modal.show 'add-key'
      'click #ur-refresh': ->
        view.refresh.refresh()

    view.helpers

  )(Template.user)

# UR: User View character list item
Meteor.startup ->
  ((view) ->

    view.helpers
      'skillName': ->
        id = @skillInTraining?.skill?.id
        if id
          return Veldspar.StaticData.skills.findOne(_id: String id).name
        else null
      'percent': ->
        info = _.extend this.skillInTraining, now:Session.get 'app.now'
        if info and info.active then Veldspar.Timing.progress info else 0
      'timeLeft': ->
        info = this.skillInTraining
        if info and info.active
          return Veldspar.Timing.diff Session.get('app.now'), info.end.date
        else null

  )(Template.ur_char_item)


# AK: Add Key
Meteor.startup ->
  ((view) ->
    Kernite.ui view

    # Multistate Controls
    view.ms =
      id: new Veldspar.FormField '#ak-id-group'
      vcode: new Veldspar.FormField '#ak-vcode-group'
      error: new Veldspar.AlertBox '#ak-error'
      submit: new Veldspar.Loader '#ak-submit'

    # Kernite Form
    view.form = new Kernite.Form
      error: (errors) ->
        for err in errors
          meta = @fields[err.id]
          meta.error err if _.isFunction meta.error
        $(errors[0].id).focus().select()
        # Setup errors
        Session.set 'add-key.error', _.map(errors, (i)->' - '+i.reason).join '\n'
        view.ms.error.state 'show'
      submit: (data) ->
        view.ms.submit.state 'loading'
        Meteor.call 'util.getApiKeyInfo', Number(data.id), data.vcode, (error, result) ->
          view.ms.submit.state 'default'
          if error
            Session.set 'add-key.error', error.reason
            view.ms.error.state 'show'
          else
            Session.set 'add-key.keyInfo', result
      success: ->
        view.ms.error.state 'hidden'
      fields:
        '#ak-id':
          name: 'id'
          next: '#ak-vcode'
          validate: (val) ->
            if not /^[0-9]+$/.test(val)
              return type:'error', reason:'**API Key ID** should be a number!'
          update: (result, reason) ->
            if result is 'ok'
              view.ms.id.state 'ok'
            else if view.ms.id.current isnt 'error'
              view.ms.id.state 'default'
          error: (error) ->
            view.ms.id.state 'error'
          success: (val) ->
            view.ms.id.state 'ok'
        '#ak-vcode':
          name: 'vcode'
          validate: (val) ->
            if not /^[a-zA-Z0-9]{64}$/.test(val)
              return type:'error', reason:'**Verification Code** should be a 64 character string!'
          update: (result, reason) ->
            if result is 'ok'
              view.ms.vcode.state 'ok'
            else if view.ms.vcode.current isnt 'error'
              view.ms.vcode.state 'default'
          error: (error) ->
            view.ms.vcode.state 'error'

    # Meteor.js events
    view.events view.form.attach
      'click #ak-submit': ->
        if not Session.get('add-key.keyInfo')
          view.form.submit()
        else
          key = Session.get 'add-key.keyInfo'
          selection = Session.get('add-key.selection') ? {}
          chars = _.chain(key.characters).filter((i)->selection[i.id])
            .map((i)->_.extend(i,
              type:'Character',
              owner:Meteor.userId(),
              apiKey: _.omit(key, 'characters', '_currentTime', '_cachedUntil')))
            .each (i) -> Veldspar.UserData.characters.insert i

          console.log chars

      'click .ak-char-item': ->
        selection = Session.get('add-key.selection') ? {}
        selection[@id] = not selection[@id]
        Session.set 'add-key.selection', selection

    # Meteor.js helpers
    view.helpers
      'selected': ->
        selection = Session.get('add-key.selection') ? {}
        return selection[@id]

    # Render callback
    view.onRender ->
      Session.set 'add-key.keyInfo', null
      Session.set 'add-key.error', null
      Session.set 'add-key.selection', null

  )(Template.add_key)
