/* Trnasformer
 * Module in charge of transforming CCP response
 * into sane Veldspar objects!
 * ----------------------------------------------
 * Copyright © 2014 Denis Luchkin-Zhou         */

if (_.isUndefined(this.Transformer)) {

  Transformer = function () {
    "use strict";
  };

  Transformer.getProperty = function (obj, prop) {
    "use strict";
    if (!prop) {
      return undefined;
    }
    /* Convert index to dot notation; remove leading dot */
    prop = prop.replace(/\[(\w+)\]/g, '.$1');
    prop = prop.replace(/^\./, '');
    var n, list = prop.split('.');
    while (list.length) {
      n = list.shift();
      if (_.isUndefined(obj[n])) {
        return;
      } else {
        obj = obj[n];
      }
    }
    return obj;
  };

  Transformer.setProperty = function (obj, prop, value) {
    "use strict";
    /* Convert index to dot notation; remove leading dot */
    prop = prop.replace(/\[(\w+)\]/g, '.$1');
    prop = prop.replace(/^\./, '');
    var n, list = prop.split('.');
    while (list.length > 1) {
      n = list.shift();
      if (!obj[n]) {
        obj[n] = {};
      }
      obj = obj[n];
    }
    obj[list[0]] = value;
  };

  Transformer.transform = function (obj, rules) {
    "use strict";
    var n,
      p,
      arr,
      result = {};

    /* Execute transform */
    for (n in rules) {
      if (_.isString(rules[n])) {
        /* string: take property value from object and assign to result */
        this.setProperty(result, n, this.getProperty(obj, rules[n]));
      } else if (_.isFunction(rules[n])) {
        /* function: invoke and assign its result */
        this.setProperty(result, n, rules[n](obj));
      } else if (_.isObject(rules[n]) && _.isString(rules[n]._path_)) {
        /* object: nested transforms */
        p = this.getProperty(obj, rules[n]._path_);
        /* If the target property is an array, transform its contents */
        if (_.isArray(p)) {
          arr = [];
          _.each(p, function (i) {
            arr.push(Transformer.transform(i, rules[n]));
          });
          this.setProperty(result, n, arr);
        } else if (_.isObject(p)) {
          /* otherwise, transform the property value */
          this.setProperty(this.transform(result, n, p));
        }
      } else {
        /* Expecting string, function or object but got something else */
        throw new Meteor.Error(19, "Unexpected transform rule!");
      }
    }

    return result;
  };

  Transformer.unwrap = function (obj) {
    "use strict";
    var n;

    /* Recursively unwrap children first */
    for (n in obj) {
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
          if (!_.isArray(rowset.row)) {
            rowset.row = [rowset.row];
          }

          /* If there is already a rowset with that name, append this one to it */
          if (!_.isUndefined(obj[rowset.name])) {
            obj[rowset.name] = _.union(obj[rowset.name], rowset.row);
          } else {
            obj[rowset.name] = rowset.row;
          }

        });
      } else {
        /* In case of a single rowset, unwrap it directly */
        if (!_.isArray(obj.rowset.row)) {
          obj.rowset.row = [obj.rowset.row];
        }
        obj[obj.rowset.name] = obj.rowset.row;
      }
    }

    /* Delete the rowset property and return */
    delete obj.rowset;

    return obj;
  };

}