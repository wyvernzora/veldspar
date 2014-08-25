Veldspar = (this ? exports).Veldspar
Kernite = (this ? exports).Kernite

# CH: Character View
Meteor.startup ->
  ((view) ->
    Kernite.ui view

    view.ms =
      refresh: new Veldspar.Refresh '#ch-refresh', 'data.updateCharacterSheet'

    view.events
      'click #ch-refresh': -> view.ms.refresh.refresh @_id



    return view
  )(Template.character)
