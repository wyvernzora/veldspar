/* Kernite UI */
Kernite = {};
Kernite.ui = function (view) {
  
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
  }
  view.rendered = function () {
    _.each(view.kern.render, function (f) { f(); })
  }
  
  /* Sideviews */
  view.left = function () { return $('#left'); }
  view.left.open = function (name, showClose, callback) {
    if (_.isUndefined(showClose)) { showClose = true; }
    Session.set('sideview', name);
    Session.set('left.showCloseButton', showClose);
    $('#gaia, #left').addClass('show-left', 'normal', callback);
    $('#overlay').show('fade', 'normal');
  }
  view.left.close = function (callback) {
    $('#overlay').hide('fade', 'normal');
    $('#gaia, #left').removeClass('show-left', 'normal', function () {
      Session.set('sideview', null);
      Session.set('left.showCloseButton', true);
      if (_.isFunction(callback)) { callback(); }
    });
  }
  
  return view;
};