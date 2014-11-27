var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

afterEach(function() {
  window.statesCollection.set([]);
  window.location.hash = '';
  Backbone.history.stop();
  return Backbone.history.handlers.length = 0;
});

describe('Marionette.Application', function() {
  var app;
  app = null;
  afterEach(function() {
    return app = null;
  });
  describe('on before start', function() {
    beforeEach(function() {
      setFixtures('<div ui-region>Region</div><div ui-region="named">Region</div>');
      app = new Marionette.Application;
      return app.start();
    });
    return it('must identify regions based on ui-region attribute', function() {
      expect(app.dynamicRegion).toEqual(jasmine.any(Marionette.Region));
      return expect(app.namedRegion).toEqual(jasmine.any(Marionette.Region));
    });
  });
  return describe('when dynamic region is not setup', function() {
    beforeEach(function() {
      setFixtures('<div ui-region="named">Region</div>');
      return app = new Marionette.Application;
    });
    return it('app.start() must throw error', function() {
      return expect(function() {
        return app.start();
      }).toThrow();
    });
  });
});

describe('Marionette.LayoutView', function() {
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
  return describe('on render of layout view', function() {
    return it('must identify regions based on ui-region', function() {
      expect(layoutView.dynamicRegion).toEqual(jasmine.any(Marionette.Region));
      return expect(layoutView.namedRegion).toEqual(jasmine.any(Marionette.Region));
    });
  });
});

describe('Marionette.Region', function() {
  beforeEach(function() {
    setFixtures(sandbox());
    return this.region = new Marionette.Region({
      el: '#sandbox'
    });
  });
  describe('When seting the controller', function() {
    beforeEach(function() {
      return this.region.setController('CtrlClass');
    });
    return it('must hold the ctrlclass property', function() {
      return expect(this.region._ctrlClass).toEqual('CtrlClass');
    });
  });
  return describe('When seting the controller states params', function() {
    beforeEach(function() {
      return this.region.setControllerStateParams([12, 23]);
    });
    return it('must hold the _ctrlStateParams property', function() {
      return expect(this.region._ctrlStateParams).toEqual([12, 23]);
    });
  });
});

describe('Marionette.RegionControllers', function() {
  describe('Lookup place for controllers', function() {
    afterEach(function() {
      return Marionette.RegionControllers.prototype.controllers = {};
    });
    describe('When the object is defined', function() {
      beforeEach(function() {
        return Marionette.RegionControllers.prototype.setLookup(window);
      });
      return it('must be define', function() {
        return expect(Marionette.RegionControllers.prototype.controllers).toEqual(window);
      });
    });
    return describe('When the object is not defined', function() {
      return it('must throw', function() {
        return expect(function() {
          return Marionette.RegionControllers.prototype.setLookup(xooma);
        }).toThrow();
      });
    });
  });
  return describe('when getting a region controller', function() {
    describe('when controller exists', function() {
      beforeEach(function() {
        return Marionette.RegionControllers.prototype.controllers = {
          'LoginCtrl': Marionette.RegionController.extend()
        };
      });
      return it('must not throw an error', function() {
        return expect(function() {
          return Marionette.RegionControllers.prototype.getRegionController('LoginCtrl');
        }).not.toThrow();
      });
    });
    return describe('when controller is not present', function() {
      return it('must throw an error', function() {
        return expect(function() {
          return Marionette.RegionControllers.prototype.getRegionController('NoCtrl');
        }).toThrow();
      });
    });
  });
});

describe('Marionette.RegionController', function() {
  describe('when initializing the region controller', function() {
    describe('when region is not passed', function() {
      return it('must throw an error', function() {
        return expect(function() {
          return new Marionette.RegionController;
        }).toThrow();
      });
    });
    return describe('when region instance is passed', function() {
      beforeEach(function() {
        setFixtures(sandbox());
        this._region = new Marionette.Region({
          el: '#sandbox'
        });
        return this.regionCtrl = new Marionette.RegionController({
          region: this._region
        });
      });
      it('must have a unique controllerid', function() {
        return expect(this.regionCtrl._ctrlID).toBeDefined();
      });
      return it('must have _region property', function() {
        return expect(this.regionCtrl._region).toEqual(this._region);
      });
    });
  });
  return describe('when showing the view inside the region', function() {
    beforeEach(function() {
      setFixtures(sandbox());
      this._region = new Marionette.Region({
        el: '#sandbox'
      });
      return this.regionCtrl = new Marionette.RegionController({
        region: this._region
      });
    });
    describe('when view is not instance of Backbone.View', function() {
      return it('must throw an error', function() {
        var regionCtrl;
        regionCtrl = this.regionCtrl;
        return expect(function() {
          return regionCtrl.show('abc');
        }).toThrow();
      });
    });
    return describe('when view instance passed', function() {
      beforeEach(function() {
        spyOn(this._region, 'show');
        spyOn(this.regionCtrl, 'trigger');
        this.view = new Marionette.ItemView();
        this.regionCtrl.show(this.view);
        return this.view.trigger('show');
      });
      it('must have _view property equal to view', function() {
        return expect(this.regionCtrl._view).toEqual(this.view);
      });
      it('must run show function on the passed region', function() {
        return expect(this._region.show).toHaveBeenCalledWith(this.view);
      });
      return describe('when the view is rendered on screen', function() {
        return it('ctrl must tigger "view:rendered" event', function() {
          return expect(this.regionCtrl.trigger).toHaveBeenCalledWith('view:rendered', this.view);
        });
      });
    });
  });
});

describe('Marionette.State', function() {
  describe('when initializing the State', function() {
    describe('when state name is not pased', function() {
      return it('must throw an error', function() {
        return expect(function() {
          return new Marionette.State;
        }).toThrow();
      });
    });
    describe('when state name is passed', function() {
      beforeEach(function() {
        spyOn(Marionette.State.prototype, 'on').and.callThrough();
        return this.state = new Marionette.State({
          'name': 'stateName'
        });
      });
      it('must listen to "change:parentStates" event', function() {
        return expect(this.state.on).toHaveBeenCalledWith('change:parentStates', this.state._processParentStates);
      });
      it('must have state name as ID', function() {
        return expect(this.state.id).toBe('stateName');
      });
      it('must have parentStates as an array', function() {
        return expect(this.state.get('parentStates')).toEqual(jasmine.any(Array));
      });
      it('must have the url property', function() {
        return expect(this.state.get('url')).toBe('/stateName');
      });
      it('must have the parent property', function() {
        return expect(this.state.get('parent')).toEqual(false);
      });
      it('must have the computed_url property', function() {
        return expect(this.state.get('computed_url')).toBe('stateName');
      });
      it('must have the url_to_array property', function() {
        return expect(this.state.get('url_to_array')).toEqual(['/stateName']);
      });
      it('must have the status property', function() {
        return expect(this.state.get('status')).toBe('inactive');
      });
      return it('must have the ctrl property', function() {
        return expect(this.state.get('ctrl')).toBe('StateNameCtrl');
      });
    });
    return describe('when full options are passed', function() {
      beforeEach(function() {
        return this.state = new Marionette.State({
          'name': 'stateName',
          'url': '/customUrl',
          'ctrl': 'MyCustomCtrl',
          'parent': 'parentState'
        });
      });
      it('must have state name as ID', function() {
        return expect(this.state.id).toBe('stateName');
      });
      it('must have the url property', function() {
        return expect(this.state.get('url')).toBe('/customUrl');
      });
      it('must have the computed_url property', function() {
        return expect(this.state.get('computed_url')).toBe('customUrl');
      });
      it('must have the parent property', function() {
        return expect(this.state.get('parent')).toEqual('parentState');
      });
      it('must have the url_to_array property', function() {
        return expect(this.state.get('url_to_array')).toEqual(['/customUrl']);
      });
      it('must have the status property', function() {
        return expect(this.state.get('status')).toBe('inactive');
      });
      return it('must have the ctrl property', function() {
        return expect(this.state.get('ctrl')).toBe('MyCustomCtrl');
      });
    });
  });
  return describe('When parentStates property changes', function() {
    beforeEach(function() {
      this.parentState1 = new Marionette.State({
        'name': 'parentState1'
      });
      this.parentState2 = new Marionette.State({
        'name': 'parentState2',
        parent: 'parentState1'
      });
      this.state = new Marionette.State({
        'name': 'stateName',
        parent: 'parenState2'
      });
      return this.state.set('parentStates', [this.parentState2, this.parentState1]);
    });
    it('must have computed_url equal to /parentState1/parentState2/stateName', function() {
      var cUrl;
      cUrl = 'parentState1/parentState2/stateName';
      return expect(this.state.get('computed_url')).toBe(cUrl);
    });
    return it('must have url_to_array ', function() {
      var arr;
      arr = ['/parentState1', '/parentState2', '/stateName'];
      return expect(this.state.get('url_to_array')).toEqual(arr);
    });
  });
});

describe('Application StateCollection', function() {
  return it('window.statesCollection must be defined', function() {
    return expect(window.statesCollection).toEqual(jasmine.any(Marionette.StateCollection));
  });
});

describe('Marionette.StateCollection', function() {
  it('must have Marionette.State as its model', function() {
    return expect(Marionette.StateCollection.prototype.model).toEqual(Marionette.State);
  });
  return describe('Adding states', function() {
    beforeEach(function() {
      var states;
      this.collection = new Marionette.StateCollection;
      states = {
        'someState': false,
        'login': {
          url: '/login'
        },
        'forgot-password': {
          url: '/forgot-password',
          ctrl: 'ForgotPwdCtrl'
        },
        'register': {
          url: '/register'
        }
      };
      return _.each(states, (function(_this) {
        return function(def, name) {
          return _this.collection.addState(name, def);
        };
      })(this));
    });
    afterEach(function() {
      return this.collection.set([]);
    });
    it('must add the states to collection', function() {
      return expect(this.collection.length).toBe(4);
    });
    return it('all states must have name and url property', function() {
      return this.collection.each(function(state) {
        expect(state.has('name')).toBe(true);
        return expect(state.has('url')).toBe(true);
      });
    });
  });
});

describe('Marionette.StateProcessor', function() {
  beforeEach(function() {
    setFixtures('<div ui-region></div>');
    this.app = new Marionette.Application;
    this.state = statesCollection.addState('stateOne');
    this.paramState = statesCollection.addState('paramState', {
      url: '/paramstate/:id',
      ctrl: 'ParamCtrl'
    });
    return Marionette.RegionControllers.prototype.controllers = {
      'StateOneCtrl': Marionette.RegionController.extend()
    };
  });
  afterEach(function() {
    return Marionette.RegionControllers.prototype.controllers = {};
  });
  return describe('When initializing the StateProcessor', function() {
    describe('when initializing without statemodel and Application instance', function() {
      return it('must throw ', function() {
        expect(function() {
          return new Marionette.StateProcessor;
        }).toThrow();
        return expect((function(_this) {
          return function() {
            return new Marionette.StateProcessor({
              state: _this.state
            });
          };
        })(this)).toThrow();
      });
    });
    describe('When initializing with statemodel and application instance', function() {
      beforeEach(function() {
        return this.stateProcessor = new Marionette.StateProcessor({
          state: this.state,
          app: this.app
        });
      });
      it('must not throw', function() {
        return expect((function(_this) {
          return function() {
            return new Marionette.StateProcessor({
              state: _this.state,
              app: _this.app
            });
          };
        })(this)).not.toThrow();
      });
      it('must have _state property', function() {
        return expect(this.stateProcessor._state).toEqual(this.state);
      });
      it('must have _deferred object', function() {
        return expect(this.stateProcessor._deferred.done).toEqual(jasmine.any(Function));
      });
      return it('must have application object', function() {
        return expect(this.stateProcessor._app).toEqual(this.app);
      });
    });
    return describe('When processing a state', function() {
      beforeEach(function() {
        this.StateCtrl = (function(_super) {
          __extends(StateCtrl, _super);

          function StateCtrl() {
            return StateCtrl.__super__.constructor.apply(this, arguments);
          }

          StateCtrl.prototype.initialize = function(options) {
            if (options == null) {
              options = {};
            }
          };

          return StateCtrl;

        })(Marionette.RegionController);
        spyOn(Marionette.RegionControllers.prototype, 'getRegionController').and.returnValue(this.StateCtrl);
        spyOn(this.StateCtrl.prototype, 'initialize');
        this.app.dynamicRegion = new Marionette.Region({
          el: $('[ui-region]')
        });
        this.setCtrlSpy = spyOn(this.app.dynamicRegion, 'setController');
        this.setCtrlParamSpy = spyOn(this.app.dynamicRegion, 'setControllerStateParams');
        this.stateProcessor = new Marionette.StateProcessor({
          state: this.state,
          app: this.app
        });
        spyOn(this.stateProcessor, 'listenTo').and.callThrough();
        return this.promise = this.stateProcessor.process();
      });
      it('must have _ctrlClass defined', function() {
        return expect(this.stateProcessor._ctrlClass).toEqual(this.StateCtrl);
      });
      it('must listen to "view:rendered" event of ctrl instance', function() {
        return expect(this.stateProcessor.listenTo).toHaveBeenCalledWith(jasmine.any(Marionette.RegionController), 'view:rendered', this.stateProcessor._onViewRendered);
      });
      it('must have _region defined', function() {
        return expect(this.stateProcessor._region).toEqual(this.app.dynamicRegion);
      });
      it('must run controller with state params', function() {
        return expect(this.StateCtrl.prototype.initialize).toHaveBeenCalledWith({
          region: this.app.dynamicRegion,
          stateParams: []
        });
      });
      it('must return the promise', function() {
        return expect(this.promise.done).toEqual(jasmine.any(Function));
      });
      it('region must store the name of ctrl with params', function() {
        expect(this.setCtrlSpy).toHaveBeenCalledWith('StateOneCtrl');
        return expect(this.setCtrlParamSpy).toHaveBeenCalledWith([]);
      });
      describe('when view is rendered in region', function() {
        beforeEach(function() {
          return this.stateProcessor._ctrlInstance.trigger('view:rendered', new Marionette.ItemView);
        });
        return it('must resovle the state', function() {
          return expect(this.stateProcessor._deferred.state()).toBe('resolved');
        });
      });
      return describe('when processing state with params', function() {
        beforeEach(function() {
          this.paramStateProcessor = new Marionette.StateProcessor({
            state: this.state,
            app: this.app,
            stateParams: [12]
          });
          return this.paramStateProcessor.process();
        });
        it('must store the state params', function() {
          return expect(this.paramStateProcessor._stateParams).toEqual([12]);
        });
        return it('must run controller with state params', function() {
          return expect(this.StateCtrl.prototype.initialize).toHaveBeenCalledWith({
            region: jasmine.any(Marionette.Region),
            stateParams: [12]
          });
        });
      });
    });
  });
});

describe('Maroinette.AppStates', function() {
  beforeEach(function() {
    this.inValidStates = {
      "": {
        url: '/someurl'
      }
    };
    return this.validStates = {
      "stateName": {
        url: '/someurl'
      },
      "stateName2": {
        url: '/statenameurl/:id'
      },
      "stateName3": {
        url: '/statename3/:id',
        parent: 'stateName2'
      },
      "stateName4": {
        url: '/statename4/:id',
        parent: 'stateName3'
      }
    };
  });
  describe('When initializing without the application object', function() {
    return it('must throw ', function() {
      return expect(function() {
        return new Marionette.AppStates;
      }).toThrow();
    });
  });
  return describe('When initializing with application object', function() {
    beforeEach(function() {
      this.app = new Marionette.Application;
      spyOn(Marionette.AppStates.prototype, '_registerStates').and.callThrough();
      spyOn(Marionette.AppStates.prototype, 'on').and.callThrough();
      return this.appStates = new Marionette.AppStates({
        app: this.app
      });
    });
    it('must have _app property', function() {
      return expect(this.appStates._app).toEqual(this.app);
    });
    it('must call _registerStates', function() {
      return expect(this.appStates._registerStates).toHaveBeenCalled();
    });
    it('must reference the global statesCollection', function() {
      return expect(this.appStates._statesCollection).toEqual(window.statesCollection);
    });
    it('must listen to "route" event', function() {
      return expect(this.appStates.on).toHaveBeenCalledWith('route', this.appStates._processStateOnRoute, this.appStates);
    });
    return describe('Registering States', function() {
      describe('register state with no name ""', function() {
        beforeEach(function() {
          var MyStates;
          return MyStates = Marionette.AppStates.extend({
            appStates: this.inValidStates
          });
        });
        return it('must throw error', function() {
          var _app;
          _app = this.app;
          return expect(function() {
            return new MyStates({
              app: _app
            });
          }).toThrow();
        });
      });
      return describe('Register state with valid definition', function() {
        beforeEach(function() {
          this.MyStates = Marionette.AppStates.extend({
            appStates: this.validStates
          });
          spyOn(window.statesCollection, 'addState').and.callThrough();
          this.routeSpy = spyOn(Backbone.Router.prototype, 'route').and.callThrough();
          this.myStates = new this.MyStates({
            app: this.app
          });
          return this.childState = statesCollection.get('stateName4');
        });
        it('must call statesCollection.addState', function() {
          return expect(window.statesCollection.addState).toHaveBeenCalledWith("stateName", {
            url: '/someurl'
          });
        });
        describe('Getting parent states of child state', function() {
          beforeEach(function() {
            return this.parentStates = this.myStates._getParentStates(this.childState);
          });
          return it('must return the array of parent states', function() {
            return expect(this.parentStates.length).toEqual(2);
          });
        });
        describe('Registering states with backbone router', function() {
          return it('must call .route() with path and state name', function() {
            expect(this.routeSpy).toHaveBeenCalledWith('statenameurl/:id', 'stateName2', jasmine.any(Function));
            return expect(this.routeSpy).toHaveBeenCalledWith('someurl', 'stateName', jasmine.any(Function));
          });
        });
        return describe('When processing route', function() {
          beforeEach(function() {
            statesCollection.addState('stateName');
            spyOn(Marionette.StateProcessor.prototype, 'initialize');
            spyOn(Marionette.StateProcessor.prototype, 'process');
            return this.stateProcessor = this.myStates._processStateOnRoute('stateName', [23]);
          });
          it('must call state processor with state model and application object', function() {
            return expect(this.stateProcessor.initialize).toHaveBeenCalledWith({
              state: jasmine.any(Marionette.State),
              app: jasmine.any(Marionette.Application),
              stateParams: [23]
            });
          });
          return it('must call process function', function() {
            return expect(this.stateProcessor.process).toHaveBeenCalled();
          });
        });
      });
    });
  });
});
