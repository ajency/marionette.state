
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
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

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
  _.extend(Marionette.Region.prototype, {
    setController: function(ctrlClass) {
      return this._ctrlClass = ctrlClass;
    },
    setControllerStateParams: function(params) {
      if (params == null) {
        params = [];
      }
      return this._ctrlStateParams = params;
    }
  });
  Marionette.RegionControllers = (function() {
    function RegionControllers() {}

    RegionControllers.prototype.controllers = {};

    RegionControllers.prototype.setLookup = function(object) {
      if (object !== window && _.isUndefined(window[object])) {
        throw new Marionette.Error('Controller lookup object is not defined');
      }
      return this.controllers = object;
    };

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
  Marionette.RegionController = (function(_super) {
    __extends(RegionController, _super);

    function RegionController(options) {
      if (options == null) {
        options = {};
      }
      if (!options.region || (options.region instanceof Marionette.Region !== true)) {
        throw new Marionette.Error({
          message: 'Region instance is not passed'
        });
      }
      this._ctrlID = _.uniqueId('ctrl-');
      this._region = options.region;
      RegionController.__super__.constructor.call(this, options);
    }

    RegionController.prototype.show = function(view) {
      if (view instanceof Backbone.View !== true) {
        throw new Marionette.Error({
          message: 'View instance is not valid Backbone.View'
        });
      }
      this._view = view;
      this.listenTo(this._view, 'show', (function(_this) {
        return function() {
          return _this.trigger('view:rendered', _this._view);
        };
      })(this));
      return this._region.show(view);
    };

    return RegionController;

  })(Marionette.Controller);
  Marionette.State = (function(_super) {
    __extends(State, _super);

    function State() {
      return State.__super__.constructor.apply(this, arguments);
    }

    State.prototype.idAttribute = 'name';

    State.prototype.defaults = function() {
      return {
        ctrl: function() {
          throw new Marionette.Error('Controller not defined');
        },
        parent: false,
        status: 'inactive'
      };
    };

    State.prototype.initialize = function(options) {
      var stateName;
      if (options == null) {
        options = {};
      }
      if (!options.name || _.isEmpty(options.name)) {
        throw new Marionette.Error('State Name must be passed');
      }
      stateName = options.name;
      if (!options.url) {
        options.url = "/" + stateName;
      }
      options.computed_url = options.url.substring(1);
      options.url_to_array = [options.url];
      if (!options.ctrl) {
        options.ctrl = this._ctrlName(stateName);
      }
      return this.set(options);
    };

    State.prototype._ctrlName = function(name) {
      return name.replace(/\w\S*/g, function(txt) {
        return txt.charAt(0).toUpperCase() + txt.substr(1) + 'Ctrl';
      });
    };

    return State;

  })(Backbone.Model);
  Marionette.StateCollection = (function(_super) {
    __extends(StateCollection, _super);

    function StateCollection() {
      return StateCollection.__super__.constructor.apply(this, arguments);
    }

    StateCollection.prototype.model = Marionette.State;

    StateCollection.prototype.addState = function(name, definition) {
      var data;
      if (definition == null) {
        definition = {};
      }
      data = {
        name: name
      };
      _.defaults(data, definition);
      return this.add(data);
    };

    return StateCollection;

  })(Backbone.Collection);
  window.statesCollection = new Marionette.StateCollection;
  Marionette.StateProcessor = (function(_super) {
    __extends(StateProcessor, _super);

    function StateProcessor() {
      this._onViewRendered = __bind(this._onViewRendered, this);
      return StateProcessor.__super__.constructor.apply(this, arguments);
    }

    StateProcessor.prototype.initialize = function(options) {
      var app, stateModel;
      if (options == null) {
        options = {};
      }
      this._state = stateModel = this.getOption('state');
      this._app = app = this.getOption('app');
      if (_.isUndefined(stateModel) || (stateModel instanceof Marionette.State !== true)) {
        throw new Marionette.Error('State model needed');
      }
      if (_.isUndefined(app) || (app instanceof Marionette.Application !== true)) {
        throw new Marionette.Error('application instance needed');
      }
      this._stateParams = options.stateParams ? options.stateParams : [];
      return this._deferred = new Marionette.Deferred();
    };

    StateProcessor.prototype.process = function() {
      var CtrlClass, ctrlInstance, _ctrlClassName, _region;
      _ctrlClassName = this._state.get('ctrl');
      this._ctrlClass = CtrlClass = Marionette.RegionControllers.prototype.getRegionController(_ctrlClassName);
      this._region = _region = this._app.dynamicRegion;
      this._region.setController(_ctrlClassName);
      this._region.setControllerStateParams(this._stateParams);
      this._ctrlInstance = ctrlInstance = new CtrlClass({
        region: _region,
        stateParams: this._stateParams
      });
      this.listenTo(ctrlInstance, 'view:rendered', this._onViewRendered);
      return this._deferred.promise();
    };

    StateProcessor.prototype.getStatus = function() {
      return this._deferred.state();
    };

    StateProcessor.prototype._onViewRendered = function() {
      return this._deferred.resolve(true);
    };

    return StateProcessor;

  })(Marionette.Object);
  Marionette.AppStates = (function(_super) {
    __extends(AppStates, _super);

    function AppStates(options) {
      if (options == null) {
        options = {};
      }
      AppStates.__super__.constructor.call(this, options);
      if (!options.app || (options.app instanceof Marionette.Application !== true)) {
        throw new Marionette.Error({
          message: 'Application instance needed'
        });
      }
      this._app = options.app;
      this._statesCollection = window.statesCollection;
      this._registerStates();
      this.on('route', this._processStateOnRoute, this);
    }

    AppStates.prototype._registerStates = function() {
      var appStates;
      appStates = Marionette.getOption(this, 'appStates');
      return _.map(appStates, (function(_this) {
        return function(stateDef, stateName) {
          var stateModel;
          if (_.isEmpty(stateName)) {
            throw new Marionette.Error('state name cannot be empty');
          }
          stateModel = _this._statesCollection.addState(stateName, stateDef);
          return _this.route(stateModel.get('computed_url'), stateModel.get('name'), function() {
            return true;
          });
        };
      })(this));
    };

    AppStates.prototype._processStateOnRoute = function(name, args) {
      var processor, stateModel;
      if (args == null) {
        args = [];
      }
      stateModel = this._statesCollection.get(name);
      processor = new Marionette.StateProcessor({
        state: stateModel,
        app: this._app,
        stateParams: args
      });
      processor.process();
      return processor;
    };

    return AppStates;

  })(Backbone.Router);
  return Marionette.State;
});
