
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

    function RegionController() {
      return RegionController.__super__.constructor.apply(this, arguments);
    }

    return RegionController;

  })(Marionette.Controller);
  return Marionette;
});
