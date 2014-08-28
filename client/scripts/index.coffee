Veldspar = (this ? exports).Veldspar
Kernite = (this ? exports).Kernite

# RT: Root Template
Meteor.startup ->
  ((view) ->
    Kernite.ui view

    # Meteor.js events
    view.events view.attach
      'click #rt-nav-logout': ->
        Meteor.logout()

    # Meteor.js helpers
    view.helpers

    view.onRender ->
      $('#rt-modal-view').on 'hidden.bs.modal', -> Session.set 'app.modal', null

  )(Template.root)


# LD: Loading View
Meteor.startup ->
  ((view) ->
    Kernite.ui view

    view.onRender ->
      Meteor.setInterval (-> $('.loading').toggleClass 'resonate'), 2000

  )(Template.loading)
