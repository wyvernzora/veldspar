/*
# Veldspar EVE Online API Client
# view.js - Reusable view logic
# Copyright © Denis Luchkin-Zhou
*/

Veldspar.UI = {};
view = Veldspar.UI.view = function () {
  
  this.Sidebar = { };
  this.Sidebar.resize = function (direction, size, callback) {
    var args = { },
        $main = $('.main', this.context),
        speed = 'fast';
    switch (direction) {
        case 'left':
          args = { 'margin-left': size, 'margin-right': '-' + size };
          break;
        case 'right':
          args = { 'margin-left': '-' + size, 'margin-right': size };
          break;
        case 'left-scale':
          args = { 'margin-left': size };
          break;
        case 'right-scale':
          args = { 'margin-right': size };
          break;
    }
    $main.animate(args, speed, function () {
      if (callback) { callback(); }
    });
};
  
  this.showError = function (context, html) {
    'use strict';
    var $err = $(context + ' .ui-state-error');
    if (html) {
      $err.html(html).hide().show('pulsate', {
        times: 2
      });
    } else {
      $err.hide('fade');
    }
  }
  
  this.forward = function (destination, callback) {
    return _.partial(function (d, c, e) {
      if (e.keyCode === 13 && (!c || c())) {
        $(d).focus();
      }
    }, destination, callback);
  }
};

