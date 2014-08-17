# Veldspar EVE Online API Client
# timing.coffee - Handles EVE Time
# Copyright © Denis Luchkin-Zhou
Veldspar = (exports ? this).Veldspar
Timing = Veldspar.Timing ?= { }


Timing.eveTime = ->
  dt = new Date();
  dt.setMinutes((new Date()).getTimezoneOffset());
  return dt;

# Gets the progress of the skill in training
Timing.progress = (sit) -> Math.round((sit.now.getTime() - sit.start.date.getTime()) / (sit.end.date.getTime() - sit.start.date.getTime()) * 100)
# Gets the time difference between start and end
Timing.diff = (start, end) ->
  result = { }
  d = Math.floor((end - start) / 1000) # seconds
  result.second = d % 60
  d = Math.floor(d / 60)  # 60s = 1m
  result.minute = d % 60
  d = Math.floor(d / 60)  # 60m = 1h
  result.hour = d % 24
  d = Math.floor(d / 24)  # 24h = 1d
  result.day = d
  return result
