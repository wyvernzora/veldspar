Veldspar = (this ? exports).Veldspar
Kernite = (this ? exports).Kernite

# Character Sheet
Meteor.startup ->
  ((view) ->

    view.helpers
      'skills': ->
        _.values @skills
      'dob': ->
        @dob.toLocaleDateString()

  )(Template['char-sheet'])
