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
    id = Meteor.users.findOne()
    Meteor.users.update {}, {$set: isAdmin: yes}
    console.log 'Default admin added.'
