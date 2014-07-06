/*
Veldspar - Meteor.js based EVE Online API client
components.js - Reusable UI component methods
Copyright © 2014 Denis Luchkin-Zhou
*/
Components = {};

// Sidebar
Components.Sidebar = {
  isOpen: false
};
Components.Sidebar.resize = function (width, direction, callback) {
  'use strict';
  var $main = $('#main-wrapper');
  // Which sidebar?
  if (direction === 'left') {
    $main.animate({
      'margin-left': width,
      'margin-right': '-' + width
    }, 'fast', callback);
  } else if (direction === 'right') {
    $main.animate({
      'margin-right': width,
      'margin-left': '-' + width
    }, 'fast', callback);
  } else if (direction === 'left-scale') {
    $main.animate({
      'margin-left': width
    }, 'fast', callback);
  } else if (direction, 'right-scale') {
    $main.animate({
      'margin-right': width
    }, 'fast', callback);
  }
};
Components.Sidebar.show = function (width, direction, callback) {
  Components.Sidebar.resize(width, direction, function () {
    Components.Sidebar.isOpen = true;
    if (_.isFunction(callback)) {
      callback();
    }
  });
};
Components.Sidebar.hide = function (direction, callback) {
  Components.Sidebar.resize('0', direction, function () {
    Components.Sidebar.isOpen = false;
    if (_.isFunction(callback)) {
      callback();
    }
  });
};

// Error box
Components.ErrorBox = {};
Components.ErrorBox.show = function (context, html) {
  'use strict';
  var $err = $(context + ' .ui-state-error');
  if (html) {
    $err.html(html).hide().show('pulsate', {
      times: 2
    });
  } else {
    $err.hide('fade');
  }
};