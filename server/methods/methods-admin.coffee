# Veldspar EVE Online API Client
# main.coffee - Meteor method definitions
# Copyright © Denis Luchkin-Zhou
Veldspar = (exports ? this).Veldspar
# Data namespaces
StaticData = Veldspar.StaticData
UserData = Veldspar.UserData

Meteor.methods
  # ---------------------------------------------------------------------------
  #   Static Data Update
  # ---------------------------------------------------------------------------

  # Public: updates skill tree data from EVE API
  'admin.updateSkillTree': ->
    console.log 'Admin.UpdateSkillTree()'
    # Authorize
    if not Meteor.user()?.isAdmin
      throw new Meteor.Error 403, 'Access denied: admin account required.'
    # Parallelize
    this.unblock()
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
          '_id': 'typeID'
          'name': 'typeName'
          'group.id': 'number:groupID'
          'published': 'bool:published'
          'description': 'description'
          'rank': 'number:rank'
          'attributes.primary': 'requiredAttributes.primaryAttribute'
          'attributes.secondary': 'requiredAttributes.secondaryAttribute'
          'prerequisites':
            '$path': 'requiredSkills'
            'id': 'typeID'
            'level': 'number:skillLevel'
          'bonus':
            '$path': 'skillBonusCollection'
            'name': 'bonusType'
            'value': 'number:bonusValue'
    raw = client.transform(transform).request()
    # Reduce skills to a flat list
    raw.skills = _(raw.groups).map((i)->i.skills)
      .reduce ((mem, o) -> mem.concat o), []
    # Replace existing skill tree data
    StaticData.skillTree.remove({})
    _.each raw.skills, (i) ->
      i.id = Number(i._id)
      StaticData.skillTree.insert i
    # Insert skill categories
    StaticData.skillCategories.remove({})
    _.each _.uniq(raw.groups, no, (o)->o.id), (i) ->
      cat = _.pick i, 'name'
      cat._id = String(i.id)
      StaticData.skillCategories.insert cat
    # Resolve skill dependencies
    resolveDeps = (skill) ->
      _.each skill.prerequisites, (i)->
        dep = StaticData.skillTree.findOne({_id: i.id}, {fields: {name: 1, prerequisites: 1, rank:1}})
        i.name = dep.name
        i.rank = dep.rank
        i.prerequisites = dep.prerequisites
        resolveDeps(i) if i.id isnt skill.id
    _.each StaticData.skillTree.find().fetch(), (i)->
      resolveDeps(i)
      StaticData.skillTree.update({_id: i._id}, _.omit(i, '_id'))

  # Public: updates certificate data from certificates.yaml
  'admin.updateCertificates': ->
    console.log 'Admin.UpdateCertificates()'
    # Authorize
    if not Meteor.user()?.isAdmin
      throw new Meteor.Error 403, 'Access denied: admin account required.'
    # Parallelize
    this.unblock()
    # Read YAML file
    try
      raw = Assets.getText 'static/certificates.yaml'
    catch
      throw new Meteor.Error 404, 'File not found: private/static/certificates.yaml'
    # .. and parse it
    raw = jsyaml.safeLoad raw
    if not raw or raw is 'undefined'
      throw new Meteor.Error 400, 'Failed to deserialize certificates.yaml'
    # Delete all existing data
    Veldspar.StaticData.certificates.remove {}
    # Do some minor transformations
    for id, cert of raw
      # TODO resolve recommendation references
      # Resolve skill references
      cert.skills = [ ] # Convert to array
      for sid, skill of cert.skillTypes
        info = Veldspar.StaticData.skillTree.findOne _id:sid  # sid is already a string
        skill.id = Number(sid)
        skill.name = info?.name ? 'UNKNOWN SKILL (BUG)'
        skill.rank = info?.rank ? 1
        skill.attributes = info?.attributes ? primary:'intelligence', secondary:'memory'
        skill.levels = [ 0, skill.basic, skill.standard, skill.improved, skill.advanced, skill.elite ] # convert into array
        cert.skills.push _.pick skill, 'id', 'name', 'rank', 'attributes', 'levels'
      delete cert.skillTypes
      # Insert into the collection
      cert._id = id
      Veldspar.StaticData.certificates.insert cert

  # Public: updates type information
  'admin.updateTypes': ->
    console.log 'Admin.UpdateTypes()'
    # Authorize
    if not Meteor.user()?.isAdmin
      throw new Meteor.Error 403, 'Access denied: admin account required.'
    # Parallelize
    this.unblock()
    # Read YAML file
    try
      properties = Assets.getText 'static/eve-properties-en-US.xml'
      types = Assets.getText 'static/eve-items-en-US.xml'
    catch
      throw new Meteor.Error 404, 'EveMon data files not found.'
    # ... create the necessary transformation rules
    propTransform =
      'categories':
        '$path': 'propertiesDatafile.category'
        'id': 'number:id'
        'name': 'name'
        'description': 'description'
        'properties':
          '$path': 'properties.property'
          '_id': 'id'
          'default': 'defaultValue'
          'description': 'description'
          'positive': 'bool:higherIsBetter'
          'icon': 'icon'
          'name': 'name'
          'unit.name': 'unit'
          'unit.id': 'unitID'
    # .. and parse it
    parser = new xml2js.Parser attrkey: '@', emptyTag: null, mergeAttrs: yes, explicitArray: no
    try
      properties = Veldspar.Transformer.transform (blocking parser, parser.parseString)(properties), propTransform
      # types = (blocking parser, parser.parseString)(types)
    catch
      throw new Meteor.Error 500, 'Failed to parse "static/eve-properties-en-US.xml"'
    # Extract categories
    categories = _.indexBy(_(properties.categories).map((i) ->
      _.pick(i, 'id', 'name', 'description')), 'id')
    # Extract properties
    properties = _(properties.categories).map((cat) ->
      _.each cat.properties, (prop) -> prop.category = name: cat.name, description: cat.description
      return cat.properties)
    # Flatten the property list
    properties = _.compact(_(properties).flatten())
    # Update database
    StaticData.properties.remove {}
    for prop in properties
      StaticData.properties.insert prop

    # Create transformation rules for the item file
    # ... it's recursive, so this will be a bit tricky.
    mktGroupTransform =
      '$path': 'marketGroups'
      'id': 'number:id'
      'name': 'name'



    return
