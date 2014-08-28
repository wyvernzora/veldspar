Veldspar = (this ? exports).Veldspar
Kernite = (this ? exports).Kernite

# Character Sheet
Meteor.startup ->
  ((view) ->

    # Utility Variables
    maxAttrValue = 32

    view.helpers
      'skills': ->
        _.values @skills
      'dob': ->
        @dob.toLocaleDateString()

      'attrWidth': (attr) ->
        base: @attributes[attr].value / maxAttrValue * 100
        bonus: @attributes[attr].bonus / maxAttrValue * 100


      'timeInCorp': ->
        dt = Veldspar.Timing.diff @date
      'joinDate': ->
        @date.toLocaleString()


  )(Template['char-sheet'])
