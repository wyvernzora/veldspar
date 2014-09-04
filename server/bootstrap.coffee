# Veldspar EVE Online API Client
# bootstrap.coffee - Default user handling
# Copyright © Denis Luchkin-Zhou
Veldspar = (this ? exports).Veldspar


Meteor.startup ->

  # Add default admin if there are no users
  if Meteor.users.find().count() is 0
    Accounts.createUser
      email: 'admin@veldspar.io'
      password: 'password'
    Meteor.users.update {}, {$set: {isAdmin: yes}}
    console.log 'No users detected: created default administrator account.'

  # Calibrate timing
  try
    console.log 'Calibrating the cache timer...'
    srvInfo = Veldspar.API.Server.getServerStatus()
    Veldspar.Timing.calibrate srvInfo._currentTime
    console.log 'Timer calibration complete: dt = ' + Veldspar.Timing.dt + 'ms'
  catch err
    console.error 'Timer calibration failed: ' + err.reason
    console.error 'Falling back to local time, but there may be up to 12 hours error.'
