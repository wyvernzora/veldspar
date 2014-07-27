/* Kernite UI */
Kernite = {};
Kernite.ui = function (view) {
  'use strict';
  
  /* Utility Namespace */
  view.util = function (methods) {
    $.extend(view.util, methods);
  };
  view.util.forward = function (destination, validate) {
    return _.partial(function (d, c, e) {
      if (e.keyCode === 13 && (!c || c())) {
        if (_.isString(d)) {
          $(d).focus();
        } else if (_.isFunction(d)) {
          d();
        }
      }
    }, destination, validate);
  };
  view.util.isEmailAddress = function (str) {
    var rgx = /^\w+(\.\w+|)*@\w+\.\w+$/;
    return str.match(rgx) !== null;
  };
  
  /* Callback Extension */
  view.kern = {};
  view.kern.render = [];
  view.onRender = function (callback) {
    if (_.isFunction(callback)) {
      view.kern.render.push(callback);
    }
  };
  view.rendered = function () {
    _.each(view.kern.render, function (f) { f(); });
  };
  
  /* Sideviews */
  view.left = function () { return $('#left'); };
  view.left.isOpen = false;
  view.left.open = function (name, callback) {
    Session.set('sideview', name);
    $('#gaia, #left').addClass('show-left', 'normal', function () {
      view.left.isOpen = true;
      if (_.isFunction(callback)) { callback(); }
    });
    $('#overlay').show('fade', 'normal');
  };
  view.left.close = function (callback) {
    $('#overlay').hide('fade', 'normal', function () {
      Session.set('sideview', null);
      Session.set('left.showCloseButton', true);
      view.left.isOpen = false;
      if (_.isFunction(callback)) { callback(); }
    });
    $('#gaia, #left').removeClass('show-left', 'normal');
  };
  
  return view;
};