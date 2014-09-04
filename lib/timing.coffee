# Veldspar EVE Online API Client
# timing.coffee - Handles EVE Time
# Copyright © Denis Luchkin-Zhou
Veldspar = (exports ? this).Veldspar
Timing = Veldspar.Timing ?= { }

Timing.dt = 0

# Calibrates Veldspar's timing against CCP's current time
Timing.calibrate = (now) ->
  if Meteor.isServer
    Timing.dt = now.getTime() - Date.now()
  if Meteor.isClient
    Meteor.call 'util.getTimerCalibration', (error, result) ->
      if error
        # PANIC!
      else
        Veldspar.Timing.dt = result.getTime() - Date.now()

Timing.eveTime = ->
  d = Date.now() + Timing.dt
  return new Date(d)

# Gets the progress of the skill in training
Timing.progress = (sit) ->
  Math.round (sit.now.getTime() - sit.start.date.getTime()) / (sit.end.date.getTime() - sit.start.date.getTime()) * 100

# Gets the time difference between start and end
Timing.diff = (start, end) ->
  start ?= Timing.eveTime()
  end ?= Timing.eveTime()
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
