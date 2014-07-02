# Veldspar EVE Online API Client
# static-data-import.coffee - Utility methods for updating static data
# Copyright © Denis Luchkin-Zhou
Veldspar = (exports ? this).Veldspar
StaticData = Veldspar.StaticData

# Internal: Fetches the skill tree data from EVE API and updates the
# existing 'static_SkillTree' collection.
StaticData.updateSkillTree = () ->
  # Request skill tree from CCP API
  client = new Veldspar.ApiClient '/eve/SkillTree.xml.aspx'
  transform =
    '_currentTime': 'date:eveapi.currentTime'
    '_cachedUntil': 'date:eveapi.cachedUntil'
    'groups':
      '$path': 'eveapi.result.skillGroups'
      'id': 'number:groupID'
      'name': 'groupName'
      'skills':
        '$path': 'skills'
        'id': 'number:typeID'
        'name': 'typeName'
        'group.id': 'number:groupID'
        'published': 'bool:published'
        'description': 'description'
        'rank': 'number:rank'
        'attributes.primary': 'requiredAttributes.primaryAttribute'
        'attributes.secondary': 'requiredAttributes.secondaryAttribute'
        'prerequisites':
          '$path': 'requiredSkills'
          'id': 'number:typeID'
          'level': 'number:skillLevel'
        'bonus':
          '$path': 'skillBonusCollection'
          'name': 'bonusType'
          'value': 'number:bonusValue'
  raw = client.transform(transform).request()
  # Reduce skills to a flat list
  raw.skills = _.reduce _.map(raw.groups, (i) -> i.skills), (mem, o) ->
    return mem.concat o
    ,[]
  # Replace existing skill tree data
  StaticData.skillTree.remove({})
  _.each raw.skills, (i) ->
    StaticData.skillTree.insert i 
  # Insert skill categories
  StaticData.skillCategories.remove({})
  _.each _.uniq(raw.groups, no, (o)->o.id), (i) ->
    StaticData.skillCategories.insert _.pick(i, 'id', 'name')
  # Resolve skill dependencies
  resolveDeps = (skill) ->
      _.each skill.prerequisites, (i)->
        dep = StaticData.skillTree.findOne({id: i.id}, {fields: {name: 1, prerequisites: 1, rank:1}})
        i.name = dep.name
        i.rank = dep.rank
        i.prerequisites = dep.prerequisites
        resolveDeps(i) if i.id isnt skill.id
  _.each StaticData.skillTree.find().fetch(), (i)->
    resolveDeps(i)
    StaticData.skillTree.update({_id: i._id}, i)

