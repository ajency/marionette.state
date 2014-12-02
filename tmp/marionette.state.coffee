###
#
# Marionette States (Marionette.State)
# State Based Routing for MarionetteJS applications.
# Much like angular's ui-router
# http://surajair.github.io/marionette.state
# --------------------------------------------------
# Version: v0.1.0
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
								message : 'Need atleast one dynamic region( [ui-region] )'
	
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
	
	
	_.extend Marionette.Region::,
	
		setController : (ctrlClass)->
			@_ctrlClass = ctrlClass
	
		setControllerStateParams : (params = [])->
			@_ctrlStateParams = params
	
		setControllerInstance :(ctrlInstance)->
			@_ctrlInstance = ctrlInstance
	
	
	class Marionette.RegionControllers
	
		controllers : {}
	
		setLookup : (object)->
			if object isnt window and _.isUndefined window[object]
				throw new Marionette.Error 'Controller lookup object is not defined'
	
			@controllers = object
	
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
	
			@_ctrlID = _.uniqueId 'ctrl-'
			@_region = options.region
			super options
	
		show : (view)->
			if view instanceof Backbone.View isnt true
				throw new Marionette.Error
					message: 'View instance is not valid Backbone.View'
	
			@_view = view
			@listenTo @_view, 'show', =>
						_.delay =>
							@trigger 'view:rendered', @_view
						, 100
			@_region.show view
	
	
	class Marionette.State extends Backbone.Model
	
		idAttribute : 'name'
	
		defaults : ->
			ctrl : -> throw new Marionette.Error 'Controller not defined'
			parent : false
			status : 'inactive'
			parentStates : []
	
		initialize : (options = {})->
			if not options.name or _.isEmpty options.name
				throw new Marionette.Error 'State Name must be passed'
	
			stateName = options.name
			options.url = "/#{stateName}" if not options.url
			options.computed_url = options.url.substring 1
			options.url_to_array = [options.url]
			options.ctrl = @_ctrlName stateName if not options.ctrl
	
			@on 'change:parentStates', @_processParentStates
	
			@set options
	
		_processParentStates : (state)->
			parentStates = state.get 'parentStates'
			computedUrl = state.get 'computed_url'
			urlToArray = state.get 'url_to_array'
	
			_.each parentStates, (pState)=>
				computedUrl = "#{pState.get('computed_url')}/#{computedUrl}"
				urlToArray.unshift pState.get('url_to_array')[0]
	
			state.set "computed_url", computedUrl
			state.set "url_to_array", urlToArray
	
		_ctrlName : (name)->
			name.replace /\w\S*/g, (txt)->
				return txt.charAt(0).toUpperCase() + txt.substr(1) + 'Ctrl'
	
		isChildState : ->
			@get('parent') isnt false
	
		hasParams : ->
			url = @get 'url'
			url.indexOf('/:') isnt -1
	
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
	
	
	class Marionette.StateProcessor extends Marionette.Object
	
		initialize : (options = {})->
			@_state = stateModel = @getOption 'state'
			@_regionContainer = _regionContainer = @getOption 'regionContainer'
	
			if _.isUndefined(stateModel) or (stateModel instanceof Marionette.State isnt true)
				throw new Marionette.Error 'State model needed'
	
			if _.isUndefined(_regionContainer) or (_regionContainer instanceof Marionette.Application isnt true and _regionContainer instanceof Marionette.View isnt true)
				throw new Marionette.Error 'regionContainer needed. This can be Application object or layoutview object'
	
			@_stateParams = if options.stateParams then options.stateParams else []
	
			@_deferred = new Marionette.Deferred()
	
		process : ->
			_ctrlClassName = @_state.get 'ctrl'
			@_region = _region = @_regionContainer.dynamicRegion
	
			#get current cotrl
			currentCtrlClass = if _region._ctrlClass then _region._ctrlClass else false
			ctrlStateParams = if _region._ctrlStateParams then _region._ctrlStateParams else false
			arrayCompare = JSON.stringify(ctrlStateParams) is JSON.stringify(@_stateParams)
			if currentCtrlClass is _ctrlClassName and arrayCompare
				@_ctrlInstance = ctrlInstance = @_region._ctrlInstance
				@listenTo ctrlInstance, 'view:rendered', @_onViewRendered
				ctrlInstance.trigger "view:rendered", ctrlInstance._view
				return @_deferred.promise()
	
			@_ctrlClass = CtrlClass = Marionette.RegionControllers::getRegionController _ctrlClassName
	
			@_ctrlInstance = ctrlInstance = new CtrlClass
												region : _region
												stateParams : @_stateParams
												stateName : @_state.get 'name'
	
			@_region.setController _ctrlClassName
			@_region.setControllerStateParams @_stateParams
			@_region.setControllerInstance ctrlInstance
			@listenTo ctrlInstance, 'view:rendered', @_onViewRendered
	
			@_deferred.promise()
	
		getStatus : ->
			@_deferred.state()
	
		_onViewRendered : =>
			@_state.set 'status', 'resolved'
			@_deferred.resolve @_ctrlInstance
	
	
	
	
	class Marionette.AppStates extends Backbone.Router
	
		constructor : (options = {})->
			super options
	
			app = options.app
	
			if app instanceof Marionette.Application isnt true
				throw new Marionette.Error
						message : 'Application instance needed'
	
			@_app  = app
			@_statesCollection = window.statesCollection
	
			# listen to route event of the router
			@on 'route', @_processStateOnRoute, @
	
			# register all app states
			@_registerStates()
	
		_registerStates : ->
	
			appStates = Marionette.getOption @, 'appStates'
	
			_.map appStates, (stateDef, stateName)=>
				if _.isEmpty stateName
					throw new Marionette.Error 'state name cannot be empty'
				@_statesCollection.addState stateName, stateDef
	
			_.map appStates, (stateDef, stateName)=>
				stateModel = @_statesCollection.get stateName
				if stateModel.isChildState()
					parentStates = @_getParentStates stateModel
					stateModel.set 'parentStates', parentStates
	
				@route stateModel.get('computed_url'), stateModel.get('name'), -> return true
	
		_getParentStates : (childState)=>
			parentStates = []
			getParentState = (state)->
				if state instanceof Marionette.State isnt true
					throw Error 'Not a valid state'
	
				parentState	= window.statesCollection.get state.get 'parent'
				parentStates.push parentState
				if parentState.isChildState()
					getParentState parentState
	
			getParentState childState
	
			parentStates
	
	
		_processStateOnRoute : (name, args = [])->
			args.pop()
			stateModel = @_statesCollection.get name
			statesToProcess = []
	
			data =
				state : stateModel
				params : []
	
			if stateModel.hasParams()
				data.params = _.flatten [args[args.length - 1]]
	
			if not stateModel.isChildState()
				data.regionContainer = @_app
	
			statesToProcess.push data
	
			if stateModel.isChildState()
				parentStates = stateModel.get('parentStates')
				k = 0
				_.each parentStates, (state, i)=>
					data = {}
					data.state = state
					data.params = []
					if state.hasParams()
						data.params = _.flatten [args[k]]
						k++
					if not state.isChildState()
						data.regionContainer = @_app
	
					statesToProcess.unshift data
	
			currentStateProcessor = Marionette.Deferred()
			processState = (index, regionContainer)->
				stateData = statesToProcess[index]
				processor = new Marionette.StateProcessor
								state : stateData.state
								regionContainer : regionContainer
								stateParams : stateData.params
				promise = processor.process()
				promise.done (ctrl)->
					if index is statesToProcess.length - 1
						currentStateProcessor.resolve processor
	
					if index < statesToProcess.length - 1
						index++
						processState index, ctrl._view
	
			processState 0, @_app
	
			currentStateProcessor.promise()
	
	
	
	
	
	
	
	
	
	
	
	
	

	Marionette.State
