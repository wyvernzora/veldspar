/*
# Veldspar EVE Online API Client
# character.js - Interaction logic for views/character.html
# Copyright © Denis Luchkin-Zhou
*/

/* Character view frame & navigation */
var main = (function (view) {
  view = Veldspar.UI.init(view);
  
  /* Private variables */
  var scrolling = false;
  
  /* Meteor.js implementation */
  view.events({
    'click .left nav li': function (e) {
      var $li = $('nav li', view.left()),
        $sel = $(e.currentTarget);
      if (!$sel.hasClass('selected')) {
        $li.removeClass('selected');
        $sel.addClass('selected');
        Session.set('character.fragment', $sel.attr('frag'));
      }
    }
  });

  view.helpers({
    'character': function () {
      return Session.get('CurrentCharacter');
    },
    'fragmentIs': function (name) {
      var frag = Session.get('character.fragment');
      if (_.isUndefined(frag) && name === '') {
        return true;
      }
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
    
    var current = Session.get('CurrentCharacter');
    Meteor.call('updateCharacters', current._id, function (err, result) {
      if (err) alert(err.reason);
      else {
        var char = Veldspar.UserData.characters.findOne({_id: current._id});
        Session.set('CurrentCharacter', char);
        console.log('updated!');
      }
    });
    
    /* Set up the scroll effect */
    $('.view .main .content').scroll(function () {
      var $content = $('.view .main .content'),
          $bar = $('.view .main .char-bar');
      if ($content.scrollTop() > 5) {
        if (scrolling) return;
        scrolling = true;
        $bar.addClass('scroll');
      } else {
        $bar.removeClass('scroll');
        scrolling = false;
      }
    });
  };
  
})(Template.character);

/* Character sheet fragment */
(function (fragment, view) {
  
  fragment = Veldspar.UI.frag(fragment);
  
  fragment.events({
    
  });
  
  fragment.helpers({
    
  });
  
  fragment.util({
    
  });
  
  fragment.rendered = function () {
    
  };
  
})(Template.fragCharacterSheet, main);

/* Skills fragment */
(function (fragment, view) {
  
  fragment = Veldspar.UI.frag(fragment);
  
  fragment.helpers({
    'name': function () {
      var skill = Veldspar.StaticData.skillTree.findOne({'id': this.id});
      if (skill) { return skill.name; }
      else { return 'UNKNOWN'; }
    }
  });
  
})(Template.fragSkills, main)