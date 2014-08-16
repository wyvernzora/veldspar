###!
Veldspar.io - Meteor.js based EveMon alternative
Copyright © 2014 Denis Luchkin-Zhou
-------------------------------------------------------------------------------
algorithms.coffee - Frequently needed algorithms
###

# Exte underscore.js for that matter
_.mixin
  # Binary Search
  binSearch: (array, target, comparator) ->
    s = 0
    e = array.length
    while s <= e
      c = (e - s) // 2 + s
      d = comparator target, array[c]
      if d > 0 then s = c + 1
      else if d < 0 then e = c - 1
      else return array[c]
    return null
