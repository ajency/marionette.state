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
	
		constructor : (options = {})->
			
			if not options.region
				throw new Marionette.Error('region param missing')
	
			@_region = options.region
	
			@_parent = options.parent ? false
	
			@_stateParams = options.stateParams ? []
	
			super options
	
		###
		# Return the region of the controlller
		###
		getRegion : ->
	
			if not @_region
				return false
	
			return @_region
	
		###
		# Return the parent controller
		# returns false if not called with parent controller
		###
		parent : ->
	
			if not @_parent
				return false
	
			return @_parent
	
		###
		# Returns the parameters passed to the controller
		###
		getParams : ->
			return @_stateParams
	
	
		###
		# renders the view inside the region
		###
		show : (view)->
			view.once 'show', => @triggerMethod 'view:show', view
			@_currentView = view
			@getRegion().show view
	
		getCurrentView : ->
			@_currentView
	
	
	
	
	
	

	Marionette