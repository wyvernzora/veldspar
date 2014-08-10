Veldspar = (this ? exports).Veldspar
Kernite = (this ? exports).Kernite

# RT: Root View
((view) ->
  Kernite.ui view
  
  scrolling = no
  
  view.events
    'click #menu': ->
      view.left.open 'menu'
    'click #logout': ->
      Meteor.logout()
  
  view.helpers
    'sideview': ->
      return switch Session.get('sideview')
        when 'signup' then Template.signup
        when 'credits' then Template.credits
        when 'add-key' then Template.addKey
        else null
    
  view.onRender ->
    $('#main-stage').scroll ->
      if $('#main-stage').scrollTop() > 5
        return if scrolling
        scrolling = yes
        $('header').addClass 'scroll'
      else
        $('header').removeClass 'scroll'
        scrolling = no
    $('#gaia #overlay').click ->
      view.left.close()
  
  view
)(Template.root)

# HD: Header View
((view) ->
  Kernite.ui view
  
  
  view
)(Template.header)