Veldspar = (this ? exports).Veldspar
Kernite = (this ? exports).Kernite

# Backbone.Router Setup
Kernite.router = Backbone.Router.extend
  routes:
    'user/:id': 'user'
    'char/:id': 'char'
    'corp/:id': 'corp'
    
  user: (id) ->
    console.log 'user!'
  
  char: (id) ->
    console.log 'char!'
    
  
  corp: (id) ->
    console.log 'corp!'
    