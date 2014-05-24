/* This file contains transformation rules for all CCP API calls */
Veldspar.Transforms = {

  /* Gets the specified property value from the object.
        obj   : Source object
        prop  : String representation of the property path.
     Returns
        Value of the property. */
  getNestedProperty: function (obj, prop) {
    prop = prop.replace(/\[(\w+)\]/g, '.$1'); // convert indexes to properties
    prop = prop.replace(/^\./, ''); // strip a leading dot
    var list = prop.split('.');
    while (list.length) {
      var n = list.shift();
      if (n in obj) {
        obj = obj[n];
      } else {
        return;
      }
    }
    return obj;
  },

  /* Sets the specified property value of the object.
     All nested objects are created as necessary.
        obj   : Source object
        prop  : String representation of the property path.
        value : New value for the specified property.
     Returns
        none */
  setNestedProperty: function (obj, prop, value) {
    prop = prop.replace(/\[(\w+)\]/g, '.$1'); // convert indexes to properties
    prop = prop.replace(/^\./, ''); // strip a leading dot
    var list = prop.split('.');
    while (list.length > 1) {
      var n = list.shift();
      if (!obj[n]) obj[n] = {};
      obj = obj[n];
    }
    obj[list[0]] = value;
  },

  /* Transforms a JSON object according to the rules.
        obj   : Source object
        rules : A map of rules in the form of { "new property" : "source property" }
                or { "new property" : function (obj) } when custom transformation is needed.
     Returns
        A JavaScript object transformed from the source object. */
  jsonTransform: function (obj, rules) {

    /* Result variable, empty for now.. */
    var result = {};

    /* Execute transformation rules */
    for (n in rules) {
      /* Check if the rule is a source property or function */
      if (_.isString(rules[n])) {
        /* Get the property value from the source object and put it into the destination object. */
        Veldspar.Transforms.setNestedProperty(result, n, Veldspar.Transforms.getNestedProperty(obj, rules[n]));
      } else if (_.isFunction(rules[n])) {
        Veldspar.Transforms.setNestedProperty(result, n, rules[n](obj));
      } else if (_.isObject(rules[n])) {
        /* Object means this is a nested transformation rule, apply it to the property */

      }
    }

    /* By this point the result should contain all the stuff needed */
    return result;
  },

  /* "Unwraps" EVE API rowset objects into arrays.
        obj   : Source object
     Returns
        The unwrapper object. */
  unwrapRowsets: function (obj) {

    /* Recursively unwrap children first */
    for (var n in obj) {
      if (obj.hasOwnProperty(n) && _.isObject(obj[n])) {
        Veldspar.Transforms.unwrapRowsets(obj[n]);
      }
    }

    /* Unwrap current object */
    if (obj.hasOwnProperty('rowset')) {
      if (_.isArray(obj.rowset)) {
        /* Unwrap all rowsets present in this object */
        _.each(obj.rowset, function (rowset) {

          /* Force-wrap rows into arrays */
          if (!_.isArray(rowset.row))
            rowset.row = [rowset.row];

          /* If there is already a rowset with that name, append this one to it */
          if (!_.isUndefined(obj[rowset.name])) {
            obj[rowset.name] = _.union(obj[rowset.name], rowset.row);
          } else {
            obj[rowset.name] = rowset.row;
          }

        });
      } else {
        /* In case of a single rowset, unwrap it directly */
        if (!_.isArray(obj.rowset.row))
          obj.rowset.row = [obj.rowset.row];
        obj[obj.rowset.name] = obj.rowset.row;
      }
    }

    /* Delete the rowset property and return */
    delete obj.rowset;

    return obj;
  }

};

/* Account Info */
Veldspar.Transforms.AccountInfo = {

  character: {
    "id": "characterID",
    "name": "characterName",
    "corp.id": "corporationID",
    "corp.name": "corporationName",
    "alliance.id": "allianceID",
    "alliance.name": "allianceName",
    "faction.id": "factionID",
    "faction.name": "factionName"
  },

  apiKeyInfo: {

    "_currentTime": "eveapi.currentTime",
    "_cachedUntil": "eveapi.cachedUntil",

    "type": "eveapi.result.key.type",
    "accessMask": "eveapi.result.key.accessMask",
    "expires": "eveapi.result.key.expires",
    "characters": {
      "_path_": "eveapi.result.key.characters",
      "id": "characterID",
      "name": "characterName",
      "corp.id": "corporationID",
      "corp.name": "corporationName",
      "alliance.id": "allianceID",
      "alliance.name": "allianceName",
      "faction.id": "factionID",
      "faction.name": "factionName"
    }


    /*function (o) {
      
      var i, l, 
          chars = new Array(),
          rawChars = Veldspar.Transforms.getNestedProperty(o, "eveapi.result.key.characters");
      
      for (i = 0, l = rawChars.length; i < l; i++) {
         chars.push(Veldspar.Transforms.jsonTransform(rawChars[i], Veldspar.Transforms.AccountInfo.character));
      }
      
      return chars;
    }*/

  },

  accountStatus: {

    "_currentTime": "eveapi.currentTime",
    "_cachedUntil": "eveapi.cachedUntil",

    "paidUntil": "eveapi.result.paidUntil",
    "createDate": "eveapi.result.createDate",
    "logonCount": "eveapi.result.logonCount",
    "logonMinutes": "eveapi.result.logonMinutes"

  },

  accountCharacters: {

    "_currentTime": "eveapi.currentTime",
    "_cachedUntil": "eveapi.cachedUntil",

    "characters": function (o) {

      var i, l,
        chars = new Array(),
        rawChars = Veldspar.Transforms.getNestedProperty(o, "eveapi.result.characters");

      for (i = 0, l = rawChars.length; i < l; i++) {
        chars.push(Veldspar.Transforms.jsonTransform(rawChars[i], Veldspar.Transforms.AccountInfo.character));
      }

      return chars;
    }
  }

}

Veldspar.Transforms.Character = {

  account: {
    "id": "accountID",
    "key": "accountKey",
    "balance": "balance"
  },

  walletBalance: {
    "_currentTime": "eveapi.currentTime",
    "_cachedUntil": "eveapi.cachedUntil",
    "accounts": function (o) {
      var accounts = new Array(),
        raw = Veldspar.Transforms.getNestedProperty(o, "eveapi.result.accounts");
      _.each(raw, function (a) {
        accounts.push(Veldspar.Transforms.jsonTransform(a, Veldspar.Transforms.Character.account));
      });
      return accounts;
    }
  },

  contact: {
    "id": "contactID",
    "name": "contactName",
    "standing": "standing"
  },

  contactList: {

  }
}