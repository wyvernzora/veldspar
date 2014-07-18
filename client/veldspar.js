
Template.header.events({
  'click #navDebug': function () {
    Session.set('showDebugView', yes);
  },
  'click #navLogout': function () {
    Meteor.logout();
    Session.set('CurrentCharacter', null);
  },
  'click #navHome': function () {
    Session.set('CurrentCharacter', null);
  },
  'click #navAdmin': function () {
    Meteor.call('updateSkillTree', function (err, result) {
      if (err) {
        alert(err.reason);
      } else {
        alert('done');
      }
    });
  }
});

Template.debug.events({
  'click #debugBtn': function () {
    $wrapper = $('#main-wrapper');
    $wrapper.animate({'margin-left': '22%'}, 20);
  }
});

Template.root.showDebugView = function () { Session.get('showDebugView'); };


UI.registerHelper('currentCharacter', function () { return Session.get('CurrentCharacter'); });
UI.registerHelper('charPortraitUri', function (size) {
  return (new Veldspar.UI.fragment()).util.getCharPortraitUri(this.id, size);
});
UI.registerHelper('corpPortraitUri', function (size) {
  return (new Veldspar.UI.fragment()).util.getCorpPortraitUri(this.id, size);
});