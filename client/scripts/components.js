/*
Veldspar - Meteor.js based EVE Online API client
components.js - Reusable UI component methods & utilities
Copyright © 2014 Denis Luchkin-Zhou
*/
Components = {};

// Utilities
Components.Util = {};
Components.Util.isEmailAddress = function (str) {
  var rgx = /^\w+(\.\w+|)*@\w+\.\w+$/;
  return str.match(rgx) !== null;
};