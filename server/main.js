/* Server Methods */

Meteor.methods({

  test: function () {

    var debugChar = JSON.parse(Asset.getText("ayase.apikey.json"));

    return Veldspar.API.Character.getAccountBalance({
      id: debugChar.key,
      code: debugChar.code,
      accessMask: debugChar.accessMask
    }, debugChar.characterID);
  }

});