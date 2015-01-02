###
#
# Marionette States (Marionette.State)
# State Based Routing for MarionetteJS applications.
# http://ajency.github.io/marionette.state
# --------------------------------------------------
# Version: v0.3.0
#
# Copyright (c) 2014 Suraj Air, Ajency.in
# Distributed under MIT license
#
###


((root, factory) ->
	Backbone = undefined
	Marionette = undefined
	_ = undefined
	if typeof define is "function" and define.amd
		define [
			"backbone"
			"underscore"
			"backbone.marionette"
		], (Backbone, _, Marionette) ->
			factory(root, Backbone, _, Marionette)

	else if typeof exports isnt "undefined"
		Backbone = require("backbone")
		_ = require("underscore")
		Marionette = require("backbone.marionette")
		module.exports = factory(root, Backbone, _, Marionette)
	else
		factory(root, root.Backbone, root._, root.Marionette)

) this, (root, Backbone, _, Marionette) ->
	"use strict"

	###
	# Region Controller
	# -----------------
	
	# Responsible for controlling the region. 
	# Showing/Removing view inside a region
	#
	# Region Controller requires a region instance as argument.
	# parentCtrl and stateParams are optional arguments 
	# Region controller will usually represent a state in an 
	# application.
	#
	###
	
	class Marionette.RegionController extends Marionette.Controller

	Marionette