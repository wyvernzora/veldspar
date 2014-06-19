# Veldspar EVE Online API Client
# static-data.coffee - Static data that changes infrequently
# Copyright © Denis Luchkin-Zhou
Veldspar = (exports ? this).Veldspar
Veldspar.Static ?= { }

# Permissions (Access Mask Permissions)
Veldspar.Static.permissions = new Meteor.Collection "st-permissions"
