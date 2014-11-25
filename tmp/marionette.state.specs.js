var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

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

describe('Marionette.States', function() {
  return describe('when the routes are configured and the controller exists', function() {
    beforeEach(function() {
      var StateRouter;
      this.LoginCtrl = jasmine.createSpy('LoginCtrl');
      StateRouter = Marionette.AppStates.extend({
        appStates: {
          'login': {
            url: 'login'
          }
        }
      });
      this.route = new StateRouter;
      Backbone.history.start();
      return this.route.navigate('login', true);
    });
    return it('must call the LoginCtrl controller ', function() {
      return expect(this.LoginCtrl).toHaveBeenCalled();
    });
  });
});
