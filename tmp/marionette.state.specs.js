var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

afterEach(function() {
  window.location.hash = '';
  Backbone.history.stop();
  return Backbone.history.handlers.length = 0;
});

window['StateOneCtrl'] = Marionette.Controller.extend();

window['StateFourCtrl'] = Marionette.Controller.extend();

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
  afterEach(function() {
    return statesCollection.set([]);
  });
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
      return this.states = new States({
        app: new Marionette.Application
      });
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
  describe('state controller', function() {
    beforeEach(function() {
      var States;
      States = Marionette.AppStates.extend({
        appStates: {
          'stateOne': {
            url: '/stateOneUrl'
          },
          'stateTwo': {
            url: '/stateTwoUrl',
            ctrl: 'CustomCtrl'
          }
        }
      });
      this.states = new States({
        app: new Marionette.Application
      });
      this.state1 = statesCollection.get('stateOne');
      return this.state2 = statesCollection.get('stateTwo');
    });
    it('must have controller property defined even if not specified', function() {
      expect(this.state1.has('ctrl')).toBeTruthy();
      return expect(this.state1.get('ctrl')).toEqual('StateOneCtrl');
    });
    return it('must override the default behavior if ctrl is provided', function() {
      return expect(this.state2.get('ctrl')).toEqual('CustomCtrl');
    });
  });
  describe('state computed url', function() {
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
          },
          'stateThree': {
            url: '/stateThreeUrl',
            parent: 'stateTwo'
          },
          'stateFour': {
            url: '/someurl/:id',
            parent: 'stateOne'
          }
        }
      });
      this.states = new States({
        app: new Marionette.Application
      });
      this.state1 = statesCollection.get('stateOne');
      this.state2 = statesCollection.get('stateTwo');
      this.state3 = statesCollection.get('stateThree');
      return this.state4 = statesCollection.get('stateFour');
    });
    return it('must append to parent url to generate state url', function() {
      expect(this.state1.get('computed_url')).toBe('stateOneUrl');
      expect(this.state2.get('computed_url')).toBe('stateOneUrl/stateTwoUrl');
      expect(this.state3.get('computed_url')).toBe('stateOneUrl/stateTwoUrl/stateThreeUrl');
      return expect(this.state4.get('computed_url')).toBe('stateOneUrl/someurl/:id');
    });
  });
  return describe('state url array', function() {
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
          },
          'stateThree': {
            url: '/stateThreeUrl',
            parent: 'stateTwo'
          }
        }
      });
      this.states = new States({
        app: new Marionette.Application
      });
      this.state1 = statesCollection.get('stateOne');
      this.state2 = statesCollection.get('stateTwo');
      return this.state3 = statesCollection.get('stateThree');
    });
    return it('must append to parent url to generate state url', function() {
      expect(this.state1.get('url_array')).toEqual(['/stateOneUrl']);
      expect(this.state2.get('url_array')).toEqual(['/stateOneUrl', '/stateTwoUrl']);
      return expect(this.state3.get('url_array')).toEqual(['/stateOneUrl', '/stateTwoUrl', '/stateThreeUrl']);
    });
  });
});

describe('Registering a state with Backbone.Router', function() {
  afterEach(function() {
    return statesCollection.set([]);
  });
  beforeEach(function() {
    var States;
    this.routeSpy = spyOn(Backbone.Router.prototype, 'route').and.callThrough();
    States = Marionette.AppStates.extend({
      appStates: {
        'stateOne': {
          url: '/stateOneUrl'
        },
        'stateTwo': {
          url: '/stateTwoUrl',
          parent: 'stateOne'
        },
        'stateThree': {
          url: '/stateThreeUrl',
          parent: 'stateTwo'
        },
        'stateFour': {
          url: '/someurl/:id',
          parent: 'stateOne'
        }
      }
    });
    this.states = new States({
      app: new Marionette.Application
    });
    this.state1 = statesCollection.get('stateOne');
    this.state2 = statesCollection.get('stateTwo');
    this.state3 = statesCollection.get('stateThree');
    return this.state4 = statesCollection.get('stateFour');
  });
  return it('must call Backbone.Router.onRoute function', function() {
    expect(this.routeSpy).toHaveBeenCalledWith(this.state1.get('computed_url'), 'stateOne', jasmine.any(Function));
    return expect(this.routeSpy).toHaveBeenCalledWith(this.state4.get('computed_url'), 'stateFour', jasmine.any(Function));
  });
});

describe('Process a state on route event', function() {
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
        },
        'stateThree': {
          url: '/stateThreeUrl',
          parent: 'stateTwo'
        },
        'stateFour': {
          url: '/someurl/:id',
          parent: 'stateOne'
        }
      }
    });
    spyOn(States.prototype, '_processState').and.callThrough();
    this.router = new States({
      app: new Marionette.Application
    });
    Backbone.history.start();
    return this.router.navigate('/stateOneUrl/someurl/100', true);
  });
  afterEach(function() {
    window.location.hash = '';
    Backbone.history.stop();
    return Backbone.history.handlers.length = 0;
  });
  return it('must call _processState with args', function() {
    expect(this.router._processState).toHaveBeenCalled();
    return expect(function() {
      return this.router._processState('stateOne');
    }).toThrow();
  });
});

describe('When processing state with no parent', function() {
  beforeEach(function() {
    var States;
    setFixtures('<div ui-region></div>');
    this.app = new Marionette.Application;
    spyOn(window, 'StateOneCtrl');
    States = Marionette.AppStates.extend({
      appStates: {
        'stateOne': {
          url: '/stateOneUrl'
        }
      }
    });
    this.app.addInitializer((function(_this) {
      return function() {
        _this.router = new States({
          app: _this.app
        });
        Backbone.history.start();
        return _this.router.navigate('/stateOneUrl', true);
      };
    })(this));
    this.app.start();
    return this.state1 = statesCollection.get('stateOne');
  });
  afterEach(function() {
    return window['StateOneCtrl'] = Marionette.Controller.extend();
  });
  it('must make the state active', function() {
    return expect(this.state1.isActive()).toBe(true);
  });
  it('must run StateOneCtrl controller', function() {
    return expect(window.StateOneCtrl).toHaveBeenCalled();
  });
  return it('must run StateOneCtrl with region', function() {
    return expect(window.StateOneCtrl).toHaveBeenCalledWith({
      region: this.app.dynamicRegion
    });
  });
});
