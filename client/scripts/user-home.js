var view = Template.userHome;

view.events({
  'click #user-home': function () {
    if (Components.Sidebar.isOpen)
      Template.addApiKey.hideSidebar();
  },
  'click #user-home .new': function () {
    Components.Sidebar.show('30%', 'left');
  },
  'click #user-home .edit': function () {
    var editMode = Session.get('userHome_Edit');
    if (editMode) {
      $('#user-home .edit').val('Edit');
      $('#user-home .delete').hide('fade', 'fast');
      Session.set('userHome_Edit', false);
      Session.set('userHome_SelectedIDs', null);
    } else {
      $('#user-home .edit').val('Cancel');
      $('#user-home .delete').show('fade', 'fast');
      Session.set('userHome_Edit', true);
    }
  },
  'click #user-home .delete': function () {
    var ids = Session.get('userHome_SelectedIDs');
    _.each(ids, function (i) {
      Veldspar.UserData.characters.remove({_id: i});
    });
    $('#user-home .edit').val('Edit');
    $('#user-home .delete').hide('fade', 'fast');
    Session.set('userHome_Edit', false);
    Session.set('userHome_SelectedIDs', null);
  },
  'click #user-home .card:not(.new)': function () {
    if (Session.get('userHome_Edit')) {
      var selection = Session.get('userHome_SelectedIDs');
      if (!selection) selection = [];
      if (_.indexOf(selection, this._id) === -1)
        selection.push(this._id);
      else
        selection = _.without(selection, this._id);
      Session.set('userHome_SelectedIDs', selection);
    } else {
      alert("WIP");
    }
  }
});

view.helpers({
  'characters': function () {
    return Veldspar.UserData.characters.find({
      type: 'Character'
    });
  },
  'editMode': function () {
    return Session.get('userHome_Edit');
  },
  'loading': function () {
    return Session.get('userHome_Loading');
  }
});

view.rendered = function () {
  //Session.set('userHome_Loading', true);
}

Template.userHomeCharCard.helpers({
  'portraitUri': function () {
    return Veldspar.Config.imageHost + '/Character/' + this.id + '_128.jpg';
  },
  'skill': function () {
    return 'Work In Progress'
  },
  'editMode': function () {
    return Session.get('userHome_Edit');
  },
  'selIconClass': function () {
    var chars = Session.get('userHome_SelectedIDs');
    if (_.indexOf(chars, this._id) !== -1) return 'ion-ios7-checkmark-outline selected';
    else return 'ion-ios7-circle-outline';
  }
});