###
#
# Marionette States (Marionette.State)
# State Based Routing for MarionetteJS applications.
# Much like angular's ui-router
# http://surajair.github.io/marionette.state
# --------------------------------------------------
# Version: v0.1.0
#
# Copyright (c) 2014 Suraj Air
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

	_.extend Marionette.Application::,
		
		start : (options = {})->
			@_detectRegions()
			@triggerMethod 'before:start', options
			@_initCallbacks.run options, @
			@triggerMethod 'start', options
	
		_detectRegions : ->
			_possibleRegions = 
			$('[ui-region]').each (index, region)=>
				regionName = $(region).attr 'ui-region'
				if _.isEmpty regionName
					regionName = 'dynamicRegion'
				else
					regionName = "#{regionName}Region"
	
				@_regionManager.addRegion regionName, selector : $(region)
	
			if _.isUndefined @dynamicRegion
				throw new Marionette.Error 
								message : 'Need atleast one dynamic region'
	_.extend Marionette.LayoutView::,
		
		render: ->
			@_ensureViewIsIntact()
	
			if @_firstRender
			  	# if this is the first render, don't do anything to
			  	# reset the regions
			  	@_firstRender = false
			else
			  	# If this is not the first render call, then we need to
			  	# re-initialize the `el` for each region
			  	@_reInitializeRegions()
			
			Marionette.ItemView.prototype.render.apply @, arguments
			@_detectRegions()
			@
	
		_detectRegions : ->
			@$el.find('[ui-region]').each (index, region)=>
				regionName = $(region).attr 'ui-region'
				if _.isEmpty regionName
					regionName = 'dynamicRegion'
				else
					regionName = "#{regionName}Region"
				@addRegion regionName, selector : $(region)
	
	class Marionette.RegionControllers
	
		controllers : {}
	
		getRegionController : (name)->
			if not _.isUndefined @controllers[name]
				return @controllers[name]
			else
				throw new Marionette.Error
							message : "#{name} controller not found"
	
	class Marionette.RegionController extends Marionette.Controller
	
		constructor : (options = {})->
	
			if not options.region or ( options.region instanceof Marionette.Region isnt true )
				throw new Marionette.Error
					message: 'Region instance is not passed'
	
			super options
	
			@_ctrlID = _.uniqueId 'ctrl-'
			@_region = options.region
	

	Marionette.State
