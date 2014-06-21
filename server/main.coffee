# Server Methods
Meteor.methods {
  
  test: ->
    char = JSON.parse Assets.getText 'ayase.apikey.json'
    return Veldspar.API.Account.getApiKeyInfo char, char.characterID
}