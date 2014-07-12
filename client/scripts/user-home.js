/*
# Veldspar EVE Online API Client
# user-home.js - Interaction logic for views/user-home.html
# Copyright © Denis Luchkin-Zhou
*/
/* Attach Veldspar.view functionality to Meteor template */
var view = Veldspar.UI.init(Template.userHome);
/* Event Handling */
view.events({
  'click .main': function () {
    view.Sidebar.resize('left', '0');
  },
  'click .main .new': function (e) {
    view.Sidebar.resize('left', '30%');
    e.stopPropagation();
  },
  'click .main .edit': function () {
    var editMode = Session.get('userHome_Edit');
    if (editMode) {
      $('.edit', view.main()).val('Edit');
      $('.delete', view.main()).hide('fade', 'fast');
      Session.set('userHome_Edit', false);
      Session.set('userHome_SelectedIDs', null);
    } else {
      $('.edit', view.main()).val('Cancel');
      $('.delete', view.main()).show('fade', 'fast');
      Session.set('userHome_Edit', true);
    }
  },
  'click .main .delete': function () {
    var ids = Session.get('userHome_SelectedIDs');
    _.each(ids, function (i) {
      Veldspar.UserData.characters.remove({
        _id: i
      });
    });
    $('.edit', view.main()).val('Edit');
    $('.delete', view.main()).hide('fade', 'fast');
    Session.set('userHome_Edit', false);
    Session.set('userHome_SelectedIDs', null);
  },
  'click .main .portrait:not(.new .portrait)': function () {
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

  'click .sidebar .cancel': function () {
    Session.set('addApiKey_ShowLoading', false);
    view.Sidebar.resize('left', '0', function () {
      view.util.reset();
    });
  },
  'click .sidebar #next': function () {
    view.util.submitKey();
  },
  'keydown .sidebar #id': view.forward('.sidebar #vcode', function () { return view.util.validateId(); }),
  'keydown .sidebar #vcode': function (e) {
    if (e.keyCode === 13) {
      view.util.submitKey();
    }
  },
  'click .sidebar .char-list .card': function () {
    var key = Session.get('addApiKey_Adding');
    var id = this.id;
    var char = _.find(key.characters, function (i) {
      return i.id === id;
    });
    char.selected = !char.selected;
    Session.set('addApiKey_Adding', key);
  },
  'click .sidebar #submit': function () {
    view.util.submit();
    Session.set('addApiKey_ShowLoading', false);
    view.Sidebar.resize('left', '0', function () {
      view.util.reset();
    });
  }
});
/* Template Helper Functions */
view.helpers({
  'characters':     function () {
    return Veldspar.UserData.characters.find({
      type: 'Character'
    });
  },
  'editMode':       function () {
    return Session.get('userHome_Edit');
  },
  'loading':        function () {
    return Session.get('userHome_Loading');
  },
  'expirationMsg':  function () {
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
  'keyCharacters':  function () {
    var key = Session.get('addApiKey_Adding');
    if (key) {
      return key.characters;
    }
  },
  'apiKeyInfo':     function () {
    return Session.get('addApiKey_Adding');
  },
  'portraitUri':    function () {
    return Veldspar.Config.imageHost + '/Character/' + this.id + '_64.jpg';
  },
  'allianceName':   function () {
    if (this.alliance.name === '') {
      return 'No Alliance';
    } else {
      return this.alliance.name;
    }
  },
  'selIconClass':   function () {
    if (this.selected) {
      return 'ion-ios7-checkmark-outline selected';
    } else {
      return 'ion-ios7-circle-outline';
    }
  },
  'showLoading':    function () {
    return Session.get('addApiKey_ShowLoading');
  }
});
/* UI Utility Functions */
view.util({
  'reset':          function () {
    $('.ui-textbox', view.side()).removeClass('ui-textbox-error').val('');
    view.Step.reset(view.side());
    view.showError(view.side(), null);
  },
  'submitKey':      function () {
    var $id = $('#id', view.side()),
        $code = $('#vcode', view.side()),
        id = Number($id.val()),
        vcode = $code.val();
    
    if (view.util.validateId() && view.util.validateVcode()) {
      Session.set('addApiKey_ShowLoading', true);
      Session.set('addApiKey_Adding', null);
      Meteor.call('getApiKeyInfo', id, vcode, function (err, result) {
        if (err) {
          view.showError(view.side(), '<b class="accented">Error ' + err.error + ': </b>' + err.reason, true);
          view.Step.prev(view.side());
          return;
        } else {
          Session.set('addApiKey_Adding', result);
        }
      });
      view.Step.next(view.side());
    }
  },
  'submit':         function () {
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

    Session.set('addApiKey_Adding', null);
  },
  'validateId':     function () {
    var $id = $('#id', view.side()),
        id = Number($id.removeClass('ui-textbox-error').val());
    if (_.isNaN(id) || id === 0) {
      $id.addClass('ui-textbox-error').focus();
      view.showError(view.side(), '<b class="accented">API Key ID</b> should be a number!');
      return false;
    }
    view.showError(view.side(), null);
    return true;
  },
  'validateVcode':  function () {
    var $code = $('#vcode', view.side()),
        vcode = $code.removeClass('ui-textbox-error').val();
    if (vcode.length !== 64) {
      $code.addClass('ui-textbox-error').focus();
      view.showError(view.side(), '<b class="accented">Verification Code</b> should be a 64-character string!');
      return false;
    }
    view.showError(view.side(), null);
    return true;
  }
});
/* Rendered Callback */
view.rendered = function () {
  view.Step.init(view.side());
  $('.character-grid').sortable({
    cancel: '.new',
    containment: 'parent'
  });
}

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