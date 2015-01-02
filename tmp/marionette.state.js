
/*
 *
 * Marionette States (Marionette.State)
 * State Based Routing for MarionetteJS applications.
 * http://ajency.github.io/marionette.state
 * --------------------------------------------------
 * Version: v0.3.0
 *
 * Copyright (c) 2014 Suraj Air, Ajency.in
 * Distributed under MIT license
 *
 */
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

  /*
  	 * Region Controller
  	 * -----------------
  	
  	 * Responsible for controlling the region. 
  	 * Showing/Removing view inside a region
  	 *
  	 * Region Controller requires a region instance as argument.
  	 * parentCtrl and stateParams are optional arguments 
  	 * Region controller will usually represent a state in an 
  	 * application.
  	 *
   */
  Marionette.RegionController = (function(_super) {
    __extends(RegionController, _super);

    function RegionController(options) {
      var _ref, _ref1;
      if (options == null) {
        options = {};
      }
      if (!options.region) {
        throw new Marionette.Error('region param missing');
      }
      this._region = options.region;
      this._parent = (_ref = options.parent) != null ? _ref : false;
      this._stateParams = (_ref1 = options.stateParams) != null ? _ref1 : [];
      RegionController.__super__.constructor.call(this, options);
    }


    /*
    		 * Return the region of the controlller
     */

    RegionController.prototype.getRegion = function() {
      if (!this._region) {
        return false;
      }
      return this._region;
    };


    /*
    		 * Return the parent controller
    		 * returns false if not called with parent controller
     */

    RegionController.prototype.parent = function() {
      if (!this._parent) {
        return false;
      }
      return this._parent;
    };


    /*
    		 * Returns the parameters passed to the controller
     */

    RegionController.prototype.getParams = function() {
      return this._stateParams;
    };


    /*
    		 * renders the view inside the region
     */

    RegionController.prototype.show = function(view) {
      view.once('show', (function(_this) {
        return function() {
          return _this.triggerMethod('view:show', view);
        };
      })(this));
      this._currentView = view;
      return this.getRegion().show(view);
    };

    RegionController.prototype.getCurrentView = function() {
      return this._currentView;
    };

    return RegionController;

  })(Marionette.Controller);
  return Marionette;
});
