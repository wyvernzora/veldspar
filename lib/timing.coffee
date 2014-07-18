# Veldspar EVE Online API Client
# timing.coffee - Handles EVE Time
# Copyright © Denis Luchkin-Zhou
Veldspar = (exports ? this).Veldspar
Timing = Veldspar.Timing ?= { }


Timing.eveTime = ->
  dt = new Date();
  dt.setMinutes((new Date()).getTimezoneOffset());
  return dt;