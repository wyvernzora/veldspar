Veldspar = (this ? exports).Veldspar
Kernite = (this ? exports).Kernite

# CH: Character View
((view) ->
  Kernite.ui view

  view.events
    'click #ch-nav-back': -> Session.set 'app.character', null

  view.helpers
    'refreshIconStyle': ->
      switch Session.get 'character.loading'
        when 'refreshing' then 'ion-refreshing'
        when 'success' then 'text-success ion-checkmark'
        when 'error' then 'text-danger ion-alert'
        else 'ion-refresh'
    'dob': ->
      @dob.toLocaleDateString()

)(Template.character)
