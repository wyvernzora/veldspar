Veldspar = (this ? exports).Veldspar
Kernite = (this ? exports).Kernite

# UR: User View
((view) ->
  Kernite.ui view


  view.helpers
    'characters': ->
      Veldspar.UserData.characters.find type:'Character'
    'corporations': ->
      Veldspar.UserData.characters.find type:'Corporation'



)(Template.user)
