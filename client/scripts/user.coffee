Veldspar = (this ? exports).Veldspar
Kernite = (this ? exports).Kernite

# User View
((view)->
  # Attach Kernite.ui functionality to view
  Kernite.ui view
  
  # Meteor.js events, helpers and callbacks
  view.events 
    
  
  
  view.helpers 
    'characters': ->
      return Veldspar.UserData.characters.find type: 'Character'
  
  
  # Kernite.ui utility functions
  view.util 
    
  
  
  view
)(Template.user)