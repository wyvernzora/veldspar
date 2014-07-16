
var view = Veldspar.UI.init(Template.character);

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
  },
  'portraitUri': function () {
    var char = Session.get('CurrentCharacter');
    return Veldspar.Config.imageHost + '/Character/' + char.id + '_256.jpg';
  }
});

view.util({
  
});

view.rendered = function () {
  $('nav ul', view.side).sortable({
    containment: 'parent'
  });
};