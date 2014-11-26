
/*
 *
 * Marionette States (Marionette.State)
 * State Based Routing for MarionetteJS applications. 
 * Much like angular's ui-router
 * http://surajair.github.io/marionette.state
 * --------------------------------------------------
 * Version: v0.1.0
 *
 * Copyright (c) 2014 Suraj Air 
 * Distributed under MIT license
 *
 */
(function(root, factory) {
  var Backbone, Marionette, _;
  Backbone = void 0;
  Marionette = void 0;
  _ = void 0;
  if (typeof define === "function" && define.amd) {
    return define(["backbone", "underscore", "backbone.marionette"], function(Backbone, _, Marionette) {
      return factory(root, Backbone, _, Marionette);
    });
  } else if (typeof exports !== "undefined") {
    Backbone = require("backbone");
    _ = require("underscore");
    Marionette = require("backbone.marionette");
    return module.exports = factory(root, Backbone, _, Marionette);
  } else {
    return factory(root, root.Backbone, root._, root.Marionette);
  }
})(this, function(root, Backbone, _, Marionette) {
  "use strict";
  _.extend(Marionette.Application.prototype, {
    start: function(options) {
      if (options == null) {
        options = {};
      }
      this._detectRegions();
      this.triggerMethod('before:start', options);
      this._initCallbacks.run(options, this);
      return this.triggerMethod('start', options);
    },
    _detectRegions: function() {
      var _possibleRegions;
      _possibleRegions = $('[ui-region]').each((function(_this) {
        return function(index, region) {
          var regionName;
          regionName = $(region).attr('ui-region');
          if (_.isEmpty(regionName)) {
            regionName = 'dynamicRegion';
          } else {
            regionName = "" + regionName + "Region";
          }
          return _this._regionManager.addRegion(regionName, {
            selector: $(region)
          });
        };
      })(this));
      if (_.isUndefined(this.dynamicRegion)) {
        throw new Marionette.Error({
          message: 'Need atleast one dynamic region'
        });
      }
    }
  });
  _.extend(Marionette.LayoutView.prototype, {
    render: function() {
      this._ensureViewIsIntact();
      if (this._firstRender) {
        this._firstRender = false;
      } else {
        this._reInitializeRegions();
      }
      Marionette.ItemView.prototype.render.apply(this, arguments);
      this._detectRegions();
      return this;
    },
    _detectRegions: function() {
      return this.$el.find('[ui-region]').each((function(_this) {
        return function(index, region) {
          var regionName;
          regionName = $(region).attr('ui-region');
          if (_.isEmpty(regionName)) {
            regionName = 'dynamicRegion';
          } else {
            regionName = "" + regionName + "Region";
          }
          return _this.addRegion(regionName, {
            selector: $(region)
          });
        };
      })(this));
    }
  });
  Marionette.RegionControllers = (function() {
    function RegionControllers() {}

    RegionControllers.prototype.controllers = {};

    RegionControllers.prototype.getRegionController = function(name) {
      if (!_.isUndefined(this.controllers[name])) {
        return this.controllers[name];
      } else {
        throw new Marionette.Error({
          message: "" + name + " controller not found"
        });
      }
    };

    return RegionControllers;

  })();
  return Marionette.State;
});
