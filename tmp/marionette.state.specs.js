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
  describe('States collection', function() {
    return it('must exists', function() {
      return expect(window.statesCollection).toEqual(jasmine.any(Marionette.StatesCollection));
    });
  });
  describe('adding states', function() {
    beforeEach(function() {
      var States;
      spyOn(statesCollection, 'addState').and.callThrough();
      States = Marionette.AppStates.extend({
        appStates: {
          'stateName': {
            url: '/stateUrl'
          },
          'stateTwo': {
            url: '/stateTwoUrl'
          }
        }
      });
      return this.states = new States;
    });
    it('must run addState on collection', function() {
      return expect(statesCollection.addState).toHaveBeenCalledWith('stateName', {
        url: '/stateUrl'
      });
    });
    it('must create a StateModel instance in collection', function() {
      return expect(statesCollection.get('stateName')).toEqual(jasmine.any(Marionette.State));
    });
    return it('must have two models in collection', function() {
      return expect(statesCollection.length).toBe(2);
    });
  });
  return describe('polyfilling state model', function() {
    beforeEach(function() {
      var States;
      States = Marionette.AppStates.extend({
        appStates: {
          'stateOne': {
            url: '/stateOneUrl'
          },
          'stateTwo': {
            url: '/stateTwoUrl',
            parent: 'stateOne'
          }
        }
      });
      this.states = new States;
      this.state1 = statesCollection.get('stateOne');
      return this.state2 = statesCollection.get('stateTwo');
    });
    return it('must have controller property defined', function() {
      expect(this.state1.has('ctrl')).toBeTruthy();
      return expect(this.state1.get('ctrl')).toEqual('StateOneCtrl');
    });
  });
});
