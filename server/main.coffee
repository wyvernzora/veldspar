# Server Methods
Meteor.methods {
  
  test: ->
    char = JSON.parse Assets.getText 'ayase.apikey.json'
    return Veldspar.API.Character.getContactNotifications char, char.characterID
}