Template.userHome.events {
  'click .new-character-card': (event) ->
    Template.addApiKey.showSidebar()
  
}

Template.userHome.characters = ->
  apiKeys = Veldspar.UserData.apiKeys.find({type: 'Account'}).fetch()
  characters = [ ]
  _.each apiKeys, (i) ->
    _.each i.characters, (c) ->
      c.apiKey = i
      characters.push(c)
  #_.sortBy characters, (i)->i.id
  _.uniq characters, no, (i)->i.id
  return characters

Template.userHomeCharCard.portraitUrl = ->
  return Veldspar.Config.imageHost + '/' + this.id + '_128.jpg'