Veldspar = (this ? exports).Veldspar
Kernite = (this ? exports).Kernite

# RT: Root View
((view) ->
  Kernite.ui view
  
  scrolling = no
  
  view.helpers
    'sideviewIs': (name) -> Session.get 'sideview' is name
    
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