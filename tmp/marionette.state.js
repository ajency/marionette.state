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
      var _possibleRegions;
      if (options == null) {
        options = {};
      }
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
      this.triggerMethod('before:start', options);
      this._initCallbacks.run(options, this);
      return this.triggerMethod('start', options);
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
      this._identifyRegions();
      return this;
    },
    _identifyRegions: function() {
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
  return Marionette.State;
});
