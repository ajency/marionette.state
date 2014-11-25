var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

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
  Marionette.State = (function(_super) {
    __extends(State, _super);

    function State() {
      return State.__super__.constructor.apply(this, arguments);
    }

    State.prototype.idAttribute = 'name';

    State.prototype.defaults = function() {
      return {
        ctrl: ''
      };
    };

    return State;

  })(Backbone.Model);
  Marionette.StatesCollection = (function(_super) {
    __extends(StatesCollection, _super);

    function StatesCollection() {
      return StatesCollection.__super__.constructor.apply(this, arguments);
    }

    StatesCollection.prototype.model = Marionette.State;

    StatesCollection.prototype.addState = function(name, definition) {
      var data, model;
      data = {
        name: name
      };
      _.defaults(data, definition);
      this.add(data);
      model = this.get(name);
      if (_.isEmpty(model.get('ctrl'))) {
        return model.set('ctrl', "" + (this.sentenceCase(name)) + "Ctrl");
      }
    };

    StatesCollection.prototype.sentenceCase = function(name) {
      return name.replace(/\w\S*/g, function(txt) {
        return txt.charAt(0).toUpperCase() + txt.substr(1);
      });
    };

    return StatesCollection;

  })(Backbone.Collection);
  window.statesCollection = new Marionette.StatesCollection;
  Marionette.AppStates = (function(_super) {
    __extends(AppStates, _super);

    function AppStates(options) {
      if (options == null) {
        options = {};
      }
      AppStates.__super__.constructor.call(this, options);
      this.appStates = Marionette.getOption(this, 'appStates');
      _.map(this.appStates, function(stateDef, stateName) {
        return statesCollection.addState(stateName, stateDef);
      });
    }

    return AppStates;

  })(Backbone.Router);
  return Marionette.State;
});
