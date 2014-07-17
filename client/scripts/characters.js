/*
# Veldspar EVE Online API Client
# character.js - Interaction logic for views/character.html
# Copyright © Denis Luchkin-Zhou
*/

/* Character view frame & navigation */
(function (view) {
  view = Veldspar.UI.init(view);

  view.events({
    'click .left nav li': function (e) {
      var $li = $('nav li', view.left()),
        $sel = $(e.currentTarget);
      if (!$sel.hasClass('selected')) {
        $li.removeClass('selected');
        $sel.addClass('selected');
      }
    }
  });

  view.helpers({
    'character': function () {
      return Session.get('CurrentCharacter');
    },
    'fragmentIs': function (name) {
      var frag = Session.get('character.fragment');
      return frag === name;
    }
  });

  view.util({

  });

  view.rendered = function () {
    /* Set default fragment: character-sheet */
    Session.set('character.fragment', 'character-sheet');
    
    /* Make the navigation bar sortable */
    $('nav ul', view.left()).sortable({
      containment: 'parent'
    });
    
  };
  
})(Template.character);

/* Character sheet fragment */
(function (fragment, view) {
  
  fragment = Veldspar.UI.init(fragment);
  
  fragment.events({
    
  });
  
  fragment.helpers({
  });
  
  fragment.util({
    
  });
  
})(Template.fragCharacterSheet, Template.character);