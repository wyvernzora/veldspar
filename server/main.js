/* Server Methods */

Meteor.methods({

  test: function () {

    var debugChar = JSON.parse(Assets.getText("ayase.apikey.json"));
    
    return Veldspar.API.Character.getContracts({
      id: debugChar.id,
      code: debugChar.code,
      accessMask: debugChar.accessMask
    }, debugChar.characterID);
  }

});