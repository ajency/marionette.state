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
	
		show : (view)->
	
			if view instanceof Backbone.View isnt true
				throw new Marionette.Error
					message: 'View instance is not valid Backbone.View'
	
			@_view = view
			@_region.show view
	
	
	class Marionette.State extends Backbone.Model
	
		idAttribute : 'name'
	
		defaults : ->
			ctrl : -> throw new Marionette.Error 'Controller not defined'
			parent : false
			status : 'inactive'
	
		initialize : (options = {})->
			if not options.name or _.isEmpty options.name
				throw new Marionette.Error 'State Name must be passed'
	
			stateName = options.name
			options.url = "/#{stateName}" if not options.url
			options.computed_url = options.url.substring 1
			options.url_to_array = [options.url]
			options.ctrl = @_ctrlName stateName if not options.ctrl
	
			@set options
	
		_ctrlName : (name)->
			name.replace /\w\S*/g, (txt)->
				return txt.charAt(0).toUpperCase() + txt.substr(1) + 'Ctrl'
	
	
	
		# isActive : ->
		# 	@get('status') is 'active'
	
		# getStatus : ->
		# 	@get 'status'
	
		# isChildState : ->
		# 	@get('parent') isnt false
	
	class Marionette.StateCollection extends Backbone.Collection
	
		model : Marionette.State
	
		addState : (name, definition = {})->
			data = name : name
			_.defaults  data, definition
			@add data
	
	
		# addState : (name, definition = {})->
		# 	data = name : name
		# 	_.defaults  data, definition
		# 	@add data
		# 	stateModel = @get name
	
		# 	# controller
		# 	if _.isEmpty stateModel.get 'ctrl'
		# 		stateModel.set 'ctrl', "#{@sentenceCase name}Ctrl"
	
		# 	# state computed URL
		# 	computedUrl = stateModel.get 'url'
		# 	computeUrl = (state)=>
		# 		parent = state.get 'parent'
		# 		parentState = @get parent
		# 		computedUrl = "#{parentState.get 'url'}#{computedUrl}"
		# 		if false isnt parentState.get 'parent'
		# 			computeUrl parentState
	
		# 	if false isnt stateModel.get 'parent'
		# 		computeUrl stateModel
	
		# 	stateModel.set 'computed_url', computedUrl.substring 1 # remove first '/'
	
		# 	# state URL array
		# 	urlArray = []
		# 	urlArray.push stateModel.get 'url'
		# 	urlToArray = (state)=>
		# 		parent = state.get 'parent'
		# 		parentState = @get parent
		# 		urlArray.push parentState.get 'url'
		# 		if false isnt parentState.get 'parent'
		# 			urlToArray parentState
	
		# 	if false isnt stateModel.get 'parent'
		# 		urlToArray stateModel
	
		# 	stateModel.set 'url_array', urlArray.reverse()
	
		# 	stateModel
	
	
	window.statesCollection = new Marionette.StateCollection
	
	class Marionette.AppStates extends Backbone.Router
	
		constructor : (options = {})->
	
			super options
	
			if not options.app or ( options.app instanceof Marionette.Application isnt true)
				throw new Marionette.Error
						message : 'Application instance needed'
	
			@_app  = options.app
			@_statesCollection = window.statesCollection
	
			# register all app states
			@_registerStates()
	
			# listen to route event of the router
			@on 'route', @_processStateOnRoute, @
	
		_registerStates : ->
	
			appStates = Marionette.getOption @, 'appStates'
	
			_.map appStates, (stateDef, stateName)=>
				if _.isEmpty stateName
					throw new Marionette.Error 'state name cannot be empty'
	
				stateModel = @_statesCollection.addState stateName, stateDef
				@route stateModel.get('computed_url'), stateModel.get('name'), -> return true
	
	
		_processStateOnRoute : (name, args = [])->
	
	
	
		# _processOnRouteState : (name, args = [])->
		# 	stateModel = window.statesCollection.get name
		# 	if stateModel.isChildState()
		# 		@_processChildState stateModel, args
		# 	else
		# 		@_processState stateModel, args
	
		# _processChildState : (stateModel, args)->
		# 	parentState = window.statesCollection.get stateModel.get 'parent'
		# 	@_processOnRouteState parentState.get('name'), args
	
		# _processState : (stateModel, args = [])->
		# 	stateModel.set 'status', 'processing'
		# 	stateModel.trigger "processing:#{stateModel.get 'name'}"
	
		# 	_region = @app.dynamicRegion
	
		# 	stateModel.set 'activeRegion', _region
	
		# 	ctrl = stateModel.get 'ctrl'
	
		# 	ControllerClass = Marionette.RegionControllers::getRegionController ctrl
	
		# 	ctrlInstance = new ControllerClass
		# 							region : _region
		# 							stateParams : args
	
		# 	stateModel.listenTo ctrlInstance, 'complete', ->
	
			# if stateModel.has('views') and false is stateModel.get 'parent'
	
			# 	views = stateModel.get 'views'
			# 	_.each views, (value, key)=>
			# 		ctrl = value['ctrl']
			# 		ControllerClass = Marionette.RegionControllers::getRegionController ctrl
	
			# 		if key is ''
			# 			_region = @app.dynamicRegion
			# 		else
			# 			_region = @app["#{key}Region"]
	
			# 		new ControllerClass
			# 			region : _region
			# 			stateParams : args
	
			# 	return
	
			# # get controller
			# ctrl = stateModel.get 'ctrl'
			# ControllerClass = Marionette.RegionControllers::getRegionController ctrl
	
			# # get the region to run controller
			# if false is stateModel.get('parent') and ( @app.dynamicRegion instanceof Marionette.Region) isnt true
			# 	throw new Marionette.Error
			# 			message : 'Dynamic region not defined for app'
	
			# if false is stateModel.get 'parent'
			# 	_region = @app.dynamicRegion
	
			# new ControllerClass
			# 		region : _region
			# 		stateParams : args
	

	Marionette.State
