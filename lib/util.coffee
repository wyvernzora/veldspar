# Veldspar EVE Online API Client
# util.coffee - Utility functions and such
# Copyright © Denis Luchkin-Zhou
Veldspar = (this ? exports).Veldspar


Veldspar.util =
  # Sorting and such
  compare:
    byName: (a, b) ->
      return 1 if a.name > b.name
      return -1 if a.name < b.name
      return 0
