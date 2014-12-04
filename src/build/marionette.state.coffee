###
#
# Marionette States (Marionette.State)
# State Based Routing for MarionetteJS applications.
# Much like angular's ui-router
# http://surajair.github.io/marionette.state
# --------------------------------------------------
# Version: v0.1.2
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

	# @include ../marionette.application.coffee
	# @include ../marionette.layoutview.coffee
	# @include ../marionette.region.coffee
	# @include ../marionette.regioncontrollers.coffee
	# @include ../marionette.regioncontroller.coffee
	# @include ../marionette.statemodel.coffee
	# @include ../marionette.statecollection.coffee
	# @include ../marionette.stateprocessor.coffee
	# @include ../marionette.appstates.coffee

	Marionette.State
