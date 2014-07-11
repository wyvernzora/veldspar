var view = $.extend(Template.userHome, new Veldspar.UI.view());

view.events({
  'click #user-home .main': function () {
    view.Sidebar.resize('left', '0');
  },
  'click #user-home .new': function (e) {
    view.Sidebar.resize('left', '30%');
    e.stopPropagation();
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
      Veldspar.UserData.characters.remove({
        _id: i
      });
    });
    $('#user-home .edit').val('Edit');
    $('#user-home .delete').hide('fade', 'fast');
    Session.set('userHome_Edit', false);
    Session.set('userHome_SelectedIDs', null);
  },
  'click #user-home .portrait:not(.new .portrait)': function () {
    if (Session.get('userHome_Edit')) {
      var selection = Session.get('userHome_SelectedIDs');
      if (!selection) selection = [];
      if (_.indexOf(selection, this._id) === -1)
        selection.push(this._id);
      else
        selection = _.without(selection, this._id);
      Session.set('userHome_SelectedIDs', selection);
    } else {
      Session.set('CurrentCharacter', this);
    }
  },

  'click #add-api-key .cancel': function () {
    Session.set('addApiKey_ShowLoading', false);
    view.Sidebar.resize('left', '0', function () {
      view.reset();
    });
  },
  'click #add-api-key #next': function () {
    view.submitKey();
  },
  'keydown #add-api-key #id': view.forward('#add-api-key #vcode', function () { return view.validateId(); }),
  'keydown #add-api-key #vcode': function (e) {
    if (e.keyCode === 13) {
      view.submitKey();
    }
  },
  'click #add-api-key .char-list .card': function () {
    var key = Session.get('addApiKey_Adding');
    var id = this.id;
    var char = _.find(key.characters, function (i) {
      return i.id === id;
    });
    char.selected = !char.selected;
    Session.set('addApiKey_Adding', key);
  },
  'click #add-api-key #submit': function () {
    view.submit();
    Session.set('addApiKey_ShowLoading', false);
    view.Sidebar.resize('left', '0', function () {
      view.reset();
    });
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
  },

  'expirationMsg': function () {
    var key = Session.get('addApiKey_Adding');
    if (key) {
      if (!key.expires) {
        return 'never expires';
      } else if (key.expires < Date.now()) {
        return 'has already expired';
      } else {
        return 'expires on ' + key.expires.toDateString();
      }
    }
  },
  'keyCharacters': function () {
    var key = Session.get('addApiKey_Adding');
    if (key) {
      return key.characters;
    }
  },
  'apiKeyInfo': function () {
    return Session.get('addApiKey_Adding');
  },
  'portraitUri': function () {
    return Veldspar.Config.imageHost + '/Character/' + this.id + '_64.jpg';
  },
  'allianceName': function () {
    if (this.alliance.name === '') {
      return 'No Alliance';
    } else {
      return this.alliance.name;
    }
  },
  'selIconClass': function () {
    if (this.selected) {
      return 'ion-ios7-checkmark-outline selected';
    } else {
      return 'ion-ios7-circle-outline';
    }
  },
  'showLoading': function () {
    return Session.get('addApiKey_ShowLoading');
  }
});

view.rendered = function () {
  $('.character-grid').sortable({
    cancel: '.new',
    containment: 'parent'
  });
}

view.reset = function () {
  $('#add-api-key #id').removeClass('ui-textbox-error').val('');
  $('#add-api-key #vcode').removeClass('ui-textbox-error').val('');
  $('#add-api-key .step').removeAttr('style');
  view.showError('#add-api-key', null);
};

view.submitKey = function () {
  if (view.validateId() && view.valiateVcode()) {
    // Start loading process
    Session.set('addApiKey_ShowLoading', true);
    Session.set('addApiKey_Adding', null);
    Meteor.call('getApiKeyInfo', id, vcode, function (err, result) {
      if (err) {
        view.showErrorMsg('<b class="accented">Error ' + err.error + ': </b>' + err.reason, true);
        $('#add-api-key .step').animate({
          'left': '+=100%'
        }, 'fast');
        return;
      } else {
        Session.set('addApiKey_Adding', result);
      }
    });
    $('#add-api-key .step').animate({
      'left': '-=100%'
    }, 'fast');
  }
};

view.submit = function () {
  var key = Session.get('addApiKey_Adding');
  var characters = _(key.characters)
    .filter(function (i) {
      return i.selected;
    })
    .map(function (i) {
      return _.omit(i, 'selected');
    });
  key.characters = undefined;

  _.each(characters, function (i) {
    i.apiKey = key;
    i.owner = Meteor.userId();
    if (key.type === 'Account' || key.type === 'Character') {
      i.type = 'Character';
    } else {
      i.type = 'Corporation';
    }
    var existing = Veldspar.UserData.characters.findOne({
      'id': i.id,
      'apiKey.id': key.id
    }, {
      fields: {
        _id: 1
      }
    });
    if (existing)
      Veldspar.UserData.characters.update({
        _id: existing._id
      }, i);
    else
      Veldspar.UserData.characters.insert(i);
  });
};

/* Validation Methods */
view.validateId = function () {
  var $id = $('#add-api-key #id'),
    id = Number($id.removeClass('ui-textbox-error').val());
  if (_.isNaN(id) || id === 0) {
    $id.addClass('ui-textbox-error').focus();
    view.showError('#add-api-key', '<b class="accented">API Key ID</b> should be a number!');
    return false;
  }
  view.showError('#add-api-key', null);
  return true;
};
view.valiateVcode = function () {
  var $code = $('#add-api-key #vcode'),
    vcode = $code.removeClass('ui-textbox-error').val();
  if (vcode.length !== 64) {
    $code.addClass('ui-textbox-error').focus();
    view.showError('#add-api-key', '<b class="accented">Verification Code</b> should be a 64-character string!');
    return false;
  }
  view.showError('#add-api-key', null);
  return true;
};

/* Nested Template Helpers */
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
    if (_.indexOf(chars, this._id) !== -1) return 'ion-ios7-close-outline selected';
    else return ''; //'ion-ios7-circle-outline';
  }
});