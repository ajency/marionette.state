var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

afterEach(function() {
  window.location.hash = '';
  Backbone.history.stop();
  return Backbone.history.handlers.length = 0;
});

window.RegionControllers = {};

window.RegionControllers['StateOneCtrl'] = Marionette.Controller.extend();

window.RegionControllers['StateTwoCtrl'] = Marionette.Controller.extend();

window.RegionControllers['StateThreeCtrl'] = Marionette.Controller.extend();

window.RegionControllers['StateFourCtrl'] = Marionette.Controller.extend();

window.RegionControllers['State1Ctrl'] = Marionette.Controller.extend();

window.RegionControllers['State2Ctrl'] = Marionette.Controller.extend();

window.RegionControllers['StateLeftCtrl'] = Marionette.Controller.extend();

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

describe('region controller lookup', function() {
  return it('must have the lookup defined', function() {
    return expect(Marionette.RegionControllers.prototype.regionControllersLookup()).toEqual(jasmine.any(Object));
  });
});

describe('when looking for region controller', function() {
  beforeEach(function() {
    Marionette.RegionController = Marionette.Controller.extend();
    return window.RegionControllers = {
      'LoginCtrl': Marionette.RegionController.extend(),
      'NoAccessCtrl': Marionette.RegionController.extend()
    };
  });
  it('must return controller if present', function() {
    var Ctrl, ctrl;
    Ctrl = Marionette.RegionControllers.prototype.getRegionController('LoginCtrl');
    ctrl = new Ctrl;
    return expect(ctrl).toEqual(jasmine.any(Marionette.RegionController));
  });
  return describe('when controller is not defined', function() {
    return it('must throw', function() {
      return expect(function() {
        return Marionette.RegionControllers.prototype.getRegionController('NoCtrl');
      }).toThrow();
    });
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
    setFixtures(sandbox());
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
    spyOn(States.prototype, '_processState');
    this.router = new States({
      app: new Marionette.Application
    });
    Backbone.history.start();
    return this.router.navigate('/stateOneUrl/stateTwoUrl', true);
  });
  afterEach(function() {
    return statesCollection.set([]);
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
    this.CtrlClass = jasmine.createSpy('StateOneCtrl');
    spyOn(Marionette.RegionControllers.prototype, 'getRegionController').and.returnValue(this.CtrlClass);
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
    return statesCollection.set([]);
  });
  it('must make the state active', function() {
    return expect(this.state1.isActive()).toBe(true);
  });
  it('must run StateOneCtrl controller', function() {
    return expect(this.CtrlClass).toHaveBeenCalled();
  });
  return it('must run StateOneCtrl with region', function() {
    var data;
    data = {
      region: this.app.dynamicRegion,
      stateParams: [null]
    };
    return expect(this.CtrlClass).toHaveBeenCalledWith(data);
  });
});

describe('When processing state with no parent and more then 1 view', function() {
  beforeEach(function() {
    var States;
    setFixtures('<div ui-region></div><div ui-region="name"></div>');
    this.app = new Marionette.Application;
    this.State1Ctrl = jasmine.createSpy('State1Ctrl');
    this.State2Ctrl = jasmine.createSpy('State2Ctrl');
    spyOn(Marionette.RegionControllers.prototype, 'getRegionController').and.callFake((function(_this) {
      return function(name) {
        return _this[name];
      };
    })(this));
    States = Marionette.AppStates.extend({
      appStates: {
        'stateOne': {
          url: '/stateOneUrl',
          views: {
            "": {
              ctrl: 'State1Ctrl'
            },
            'name': {
              ctrl: 'State2Ctrl'
            }
          }
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
    return statesCollection.set([]);
  });
  it('must run SomeCtrl in dynamic region', function() {
    var data;
    data = {
      region: this.app.dynamicRegion,
      stateParams: [null]
    };
    return expect(this.State1Ctrl).toHaveBeenCalledWith(data);
  });
  return it('must run SomeNameCtrl in app.nameRegion', function() {
    var data;
    data = {
      region: this.app.nameRegion,
      stateParams: [null]
    };
    return expect(this.State2Ctrl).toHaveBeenCalledWith(data);
  });
});
