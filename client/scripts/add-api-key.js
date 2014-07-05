var view = Template.addApiKey;

view.events({
  'click #add-api-key .cancel': function () {
    view.hideSidebar();
  },
  'click #add-api-key #next': function () {
    view.submitKey();
  },
  'keydown #add-api-key #id': function (e) {
    if (e.keyCode === 13) {
      $('#add-api-key #vcode').focus();
    }
  },
  'keydown #add-api-key #vcode': function (e) {
    if (e.keyCode === 13) {
      view.submitKey();
    }
  },
  'click #add-api-key .char-list-item': function () {
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
    view.hideSidebar();
  }
});

view.helpers({
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
  'characters': function () {
    return Session.get('addApiKey_Adding').characters;
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
      return 'ion-ios7-checkmark-outline char-sel';
    } else {
      return 'ion-ios7-circle-outline';
    }
  },
  'showLoading': function () {
    return Session.get('addApiKey_ShowLoading');
  }
});

view.hideSidebar = function () {
  Session.set('addApiKey_ShowLoading', false);
  Components.Sidebar.hide('left', function () {
    $('#add-api-key .ui-textbox').val('');
    view.reset();
  });
};

view.reset = function () {
  $('#add-api-key #id').removeClass('ui-textbox-error');
  $('#add-api-key #vcode').removeClass('ui-textbox-error');
  $('#add-api-key #step-one').removeAttr('style');
  $('#add-api-key #step-two').removeAttr('style');
  $('#add-api-key #error').hide();
};

view.submitKey = function () {
  // Get input fields
  var $id = $('#add-api-key #id');
  var $code = $('#add-api-key #vcode');
  // Hide error messages
  view.showErrorMsg(null, true);
  // Verify values
  var id = Number($id.removeClass('ui-textbox-error').val());
  var vcode = $code.removeClass('ui-textbox-error').val();
  if (_.isNaN(id) || id === 0) {
    $id.addClass('ui-textbox-error').focus();
    view.showErrorMsg('<b class="accented">API Key ID</b> should be a number!');
    return;
  }
  if (vcode.length !== 64) {
    $code.addClass('ui-textbox-error').focus();
    view.showErrorMsg('<b class="accented">Verification Code</b> should be a 64-character string!');
    return;
  }
  // Start loading process
  Session.set('addApiKey_ShowLoading', true);
  Session.set('addApiKey_Adding', null);
  Meteor.call('getApiKeyInfo', id, vcode, function (err, result) {
    if (err) {
      alert(err.reason);
      Session.set('veldspar_error', err);
    } else {
      Session.set('addApiKey_Adding', result);
    }
  });
  $('#add-api-key .step').animate({
    'left': '-=100%'
  }, 'fast');
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

view.showErrorMsg = function (html, noAnimation) {
  $err = $('#add-api-key #error');
  if (html) {
    $err.html(html).hide().show('pulsate', {
      times: 2
    });
  } else if (noAnimation) {
    $err.hide();
  } else {
    $err.hide();
  }
};