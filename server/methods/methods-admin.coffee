# Veldspar EVE Online API Client
# main.coffee - Meteor method definitions
# Copyright © Denis Luchkin-Zhou
Veldspar = (exports ? this).Veldspar
# Data namespaces
StaticData = Veldspar.StaticData
UserData = Veldspar.UserData
Cache = Veldspar.Cache

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
            'id': 'typeID'
            'level': 'number:skillLevel'
          'bonus':
            '$path': 'skillBonusCollection'
            'name': 'bonusType'
            'value': 'number:bonusValue'
    raw = client.transform(transform).request()

    # Delete the entire skill collection
    StaticData.skills.remove {}

    # Extract categories
    categories = _.indexBy _(raw.groups).uniq(no, (i) -> i.id), 'id'

    # Flatten skill data
    skills = _.flatten _(raw.groups).pluck('skills')
    for skill in skills
      # Resolve skill group
      skill.group = categories[skill.group.id]?.name ? 'Unspecified'
      # Insert into database
      StaticData.skills.insert skill

    # Resolve skill prerequisites
    resolveDeps = (skill) ->
      for i in skill.prerequisites
        dep = StaticData.skills.findOne({_id: String(i.id)}, {fields: {name: 1, prerequisites: 1, rank:1}})
        i.name = dep.name
        i.rank = dep.rank
        i.prerequisites = dep.prerequisites
        resolveDeps(i) if i.id isnt skill.id
    for skill in skills
      resolveDeps skill
      StaticData.skills.update {_id:skill._id}, {$set: {prerequisites: skill.prerequisites}}

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

    # Issue an API call to get skill categories
    client = new Veldspar.ApiClient '/eve/SkillTree.xml.aspx'
    transform =
      'groups':
        '$path': 'eveapi.result.skillGroups'
        'id': 'number:groupID'
        'name': 'groupName'
    rawCats = client.transform(transform).request()

    # Extract categories
    categories = _.indexBy _(rawCats.groups).uniq(no, (i) -> i.id), 'id'

    # Delete all existing data
    Veldspar.StaticData.certificates.remove {}

    # Do some minor transformations
    for id, cert of raw
      # TODO resolve recommendation references
      # Resolve skill references
      cert.skills = [ ] # Convert to array
      cert.group = categories[cert.groupID]?.name ? 'Unspecified'
      delete cert.groupID
      for sid, skill of cert.skillTypes
        info = StaticData.skills.findOne _id:sid  # sid is already a string
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

  # ---------------------------------------------------------------------------
  #   Developer Tools
  # ---------------------------------------------------------------------------
  'dev.dropCacheTimeout': (charid) ->
    console.log 'Admin.UpdateSkillTree()'
    # Authorize
    if not Meteor.user()?.isAdmin
      throw new Meteor.Error 403, 'Access denied: admin account required.'
    # Get character
    # Find current character data and make sure there is such
    char = UserData.characters.findOne({'owner': @userId, '_id': charid})
    if not char
      throw new Meteor.Error 404, 'Not found: the capsuleer you are looking for is not here.'
      return
    # Parallelize
    this.unblock()
    # Set all cache timers to a long time ago
    Cache.timers.update {charId: char.id}, {$set: { timer: new Date(0) }}, {multi: yes}
