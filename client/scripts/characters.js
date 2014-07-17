/*
# Veldspar EVE Online API Client
# character.js - Interaction logic for views/character.html
# Copyright © Denis Luchkin-Zhou
*/
/* Character view frame & navigation */
(function (view) {
  view = Veldspar.UI.init(view);

  view.events({
    'click .sidebar nav li': function (e) {
      var $li = $('nav li', view.side),
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
    }
  });

  view.util({

  });

  view.rendered = function () {
    $('nav ul', view.side).sortable({
      containment: 'parent'
    });
    
  };
  
})(Template.character);
/* Character sheet view */
(function (view) {
  view = Veldspar.UI.init(view);
  
  view.events({
    
  });
  
  view.helpers({
    'portraitUri': function () {
      var char = Session.get('CurrentCharacter');
      if (char) { return view.util.getCharPortraitUri(char.id, 256); }
      else return null;
    }
  });
  
  view.util({
    
  });
  
})(Template.subCharacterSheet);