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
  return describe('when initializing the region controller', function() {
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
});
