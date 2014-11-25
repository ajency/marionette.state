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
        ctrl: '',
        parent: false,
        status: 'inactive'
      };
    };

    State.prototype.isActive = function() {
      return this.get('status') === 'active';
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
      var computeUrl, computedUrl, data, stateModel, urlArray, urlToArray;
      if (definition == null) {
        definition = {};
      }
      data = {
        name: name
      };
      _.defaults(data, definition);
      this.add(data);
      stateModel = this.get(name);
      if (_.isEmpty(stateModel.get('ctrl'))) {
        stateModel.set('ctrl', "" + (this.sentenceCase(name)) + "Ctrl");
      }
      computedUrl = stateModel.get('url');
      computeUrl = (function(_this) {
        return function(state) {
          var parent, parentState;
          parent = state.get('parent');
          parentState = _this.get(parent);
          computedUrl = "" + (parentState.get('url')) + computedUrl;
          if (false !== parentState.get('parent')) {
            return computeUrl(parentState);
          }
        };
      })(this);
      if (false !== stateModel.get('parent')) {
        computeUrl(stateModel);
      }
      stateModel.set('computed_url', computedUrl.substring(1));
      urlArray = [];
      urlArray.push(stateModel.get('url'));
      urlToArray = (function(_this) {
        return function(state) {
          var parent, parentState;
          parent = state.get('parent');
          parentState = _this.get(parent);
          urlArray.push(parentState.get('url'));
          if (false !== parentState.get('parent')) {
            return urlToArray(parentState);
          }
        };
      })(this);
      if (false !== stateModel.get('parent')) {
        urlToArray(stateModel);
      }
      stateModel.set('url_array', urlArray.reverse());
      return stateModel;
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
      var states;
      if (options == null) {
        options = {};
      }
      AppStates.__super__.constructor.call(this, options);
      if (!options.app || (options.app instanceof Marionette.Application !== true)) {
        throw new Marionette.Error({
          message: 'Application instance needed'
        });
      }
      this.app = options.app;
      this.appStates = Marionette.getOption(this, 'appStates');
      states = [];
      _.map(this.appStates, function(stateDef, stateName) {
        return states.push(statesCollection.addState(stateName, stateDef));
      });
      _.each(states, function(state) {
        return this.route(state.get('computed_url'), state.get('name'), function() {
          return true;
        });
      }, this);
      this.on('route', this._processState, this);
    }

    AppStates.prototype._processState = function(name, args) {
      var ctrl, stateModel, views, _region;
      if (args == null) {
        args = [];
      }
      stateModel = window.statesCollection.get(name);
      stateModel.set('status', 'active');
      if (stateModel.has('views') && false === stateModel.get('parent')) {
        views = stateModel.get('views');
        _.each(views, (function(_this) {
          return function(value, key) {
            var ctrl, _region;
            ctrl = value['ctrl'];
            if (_.isUndefined(window[ctrl])) {
              throw new Marionette.Error({
                message: 'Controller not defined. Define a controller at window.' + ctrl
              });
            }
            if (key === '') {
              _region = _this.app.dynamicRegion;
            } else {
              _region = _this.app["" + key + "Region"];
            }
            return new window[ctrl]({
              region: _region,
              stateParams: args
            });
          };
        })(this));
        return;
      }
      ctrl = stateModel.get('ctrl');
      if (_.isUndefined(window[ctrl])) {
        throw new Marionette.Error({
          message: 'Controller not defined. Define a controller at window.' + ctrl
        });
      }
      if (false === stateModel.get('parent') && (this.app.dynamicRegion instanceof Marionette.Region) !== true) {
        throw new Marionette.Error({
          message: 'Dynamic region not defined for app'
        });
      }
      if (false === stateModel.get('parent')) {
        _region = this.app.dynamicRegion;
      }
      return new window[ctrl]({
        region: _region,
        stateParams: args
      });
    };

    return AppStates;

  })(Backbone.Router);
  return Marionette.State;
});
