var clearCurrentUser, setCurrentUser,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

window.FB = {
  login: function() {},
  api: function(url, cb) {
    return cb({
      email: 'someemail@mail.com'
    });
  }
};

window.APIURL = 'http://localhost/project/wp-api';

setCurrentUser = function() {
  var userData;
  userData = {
    ID: 1,
    user_name: 'admin',
    user_email: 'admin@mailinator.com',
    caps: {
      edit_post: true,
      read_others_post: false
    }
  };
  return window.currentUser.set(userData);
};

clearCurrentUser = function() {
  return window.currentUser.clear();
};

beforeEach(function() {
  this.setFixtures = setFixtures;
  return this.loadFixtures = loadFixtures;
});

afterEach(function() {
  window.location.hash = '';
  Backbone.history.stop();
  return Backbone.history.handlers.length = 0;
});

describe('Marionette.Application on before start', function() {
  var app;
  app = null;
  beforeEach(function() {
    setFixtures('<div ui-region>Region</div><div ui-region="named">Region</div>');
    app = new Marionette.Application;
    return app.start();
  });
  return it('must identify regions based on ui-region ', function() {
    expect(app.dynamicRegion).toEqual(jasmine.any(Marionette.Region));
    return expect(app.namedRegion).toEqual(jasmine.any(Marionette.Region));
  });
});

describe('Marionette.LayoutView on render', function() {
  var layoutView;
  layoutView = null;
  beforeEach(function() {
    var LV;
    LV = (function(_super) {
      __extends(LV, _super);

      function LV() {
        return LV.__super__.constructor.apply(this, arguments);
      }

      LV.prototype.template = '<div> <div ui-region>Region</div> <div ui-region="named">Region named</div> </div>';

      return LV;

    })(Marionette.LayoutView);
    layoutView = new LV;
    return layoutView.render();
  });
  return it('must identify regions based on ui-region', function() {
    expect(layoutView.dynamicRegion).toEqual(jasmine.any(Marionette.Region));
    return expect(layoutView.namedRegion).toEqual(jasmine.any(Marionette.Region));
  });
});
