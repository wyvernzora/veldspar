var view = Template.userHome;

view.events({
  'click #user-home': function () {
    if (Components.Sidebar.isOpen)
      Template.addApiKey.hideSidebar();
  },
  'click .new-character-card': function () {
    Components.Sidebar.show('30%', 'left');
  },
  'click #user-home .edit': function () {
    var editMode = Session.get('userHome_Edit');
    if (editMode) {
      $('#user-home .edit').val('Edit');
      Session.set('userHome_Edit', false);
      Session.set('userHome_SelectedIDs', null);
    } else {
      $('#user-home .edit').val('Cancel');
      Session.set('userHome_Edit', true);
    }
  },
  'click #user-home .character-card:not(.new-character-card)': function () {
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
  }
});

Template.userHomeCharCard.helpers({
  'portraitUri': function () {
    return Veldspar.Config.imageHost + '/Character/' + this.id + '_128.jpg';
  },
  'editMode': function () {
    return Session.get('userHome_Edit');
  },
  'selIconClass': function () {
    var chars = Session.get('userHome_SelectedIDs');
    if (_.indexOf(chars, this._id) !== -1) return 'ion-ios7-checkmark-outline char-sel';
    else return 'ion-ios7-circle-outline';
  }
});