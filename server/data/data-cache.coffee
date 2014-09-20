# Veldspar EVE Online API Client
# static-data-import.coffee - Utility methods for updating static data
# Copyright © Denis Luchkin-Zhou
Veldspar = (exports ? this).Veldspar
Cache = Veldspar.Cache

# Server-only Data
Cache.timers = new Meteor.Collection 'cache.Timers'

# Entity names
Meteor.publish 'cache.EntityNames', -> Cache.entityNames.find()


Cache.resolveEntityNames = (IDs) ->
  # Ensure that IDs are unique
  IDs = _.uniq IDs
  # Convert IDs to strings
  IDs = _.map IDs, (i) -> String i
  # Find already cached ones
  cached = _.indexBy(Cache.entityNames.find(_id: $in: IDs).fetch(), '_id')
  # Get those that were not found
  IDs = _(IDs).filter((i)->not cached[i])
  # Request CCP for those names
  response = _.indexBy(Veldspar.API.Eve.getCharacterName(IDs), 'id')
  # Cache the response
  for id, name of response
    Veldspar.Cache.entityNames.update {_id:id}, {name: name}, true
  # Return thje combined results
  return _.extend cached, response
