var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

afterEach(function() {
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
    return it('ap.start() must throw error', function() {
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

describe('Marionette.RegionControllers', function() {
  return describe('when getting a region controller', function() {
    describe('when controller exists', function() {
      beforeEach(function() {
        return Marionette.RegionControllers.prototype.controllers = {
          'LoginCtrl': Marionette.Controller.extend()
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
        this.view = new Marionette.ItemView();
        return this.regionCtrl.show(this.view);
      });
      it('must have _view property equal to view', function() {
        return expect(this.regionCtrl._view).toEqual(this.view);
      });
      return it('must run show function on the passed region', function() {
        return expect(this._region.show).toHaveBeenCalledWith(this.view);
      });
    });
  });
});

describe('Marionette.State', function() {
  return describe('when initializing the State', function() {
    describe('when state name is not pased', function() {
      return it('must throw an error', function() {
        return expect(function() {
          return new Marionette.State;
        }).toThrow();
      });
    });
    describe('when state name is passed', function() {
      beforeEach(function() {
        return this.state = new Marionette.State({
          'name': 'stateName'
        });
      });
      it('must have state name as ID', function() {
        return expect(this.state.id).toBe('stateName');
      });
      it('must have the url property', function() {
        return expect(this.state.get('url')).toBe('/stateName');
      });
      it('must have the parent property', function() {
        return expect(this.state.get('parent')).toEqual(false);
      });
      it('must have the computed_url property', function() {
        return expect(this.state.get('computed_url')).toBe('/stateName');
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
        return expect(this.state.get('computed_url')).toBe('/customUrl');
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

describe('Maroinette.AppStates', function() {
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
    return describe('Registering States', function() {
      describe('register state with no name ""', function() {
        beforeEach(function() {
          var MyStates;
          return MyStates = Marionette.AppStates.extend({
            appStates: {
              "": {
                url: '/someurl'
              }
            }
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
      return describe('register state with valid definition', function() {
        beforeEach(function() {
          var MyStates;
          MyStates = Marionette.AppStates.extend({
            appStates: {
              "stateName": {
                url: '/someurl'
              },
              "stateName2": {
                url: '/statenameurl'
              }
            }
          });
          spyOn(window.statesCollection, 'addState');
          return this.myStates = new MyStates({
            app: this.app
          });
        });
        return it('must call statesCollection.addState', function() {
          return expect(window.statesCollection.addState).toHaveBeenCalled();
        });
      });
    });
  });
});
