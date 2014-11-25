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
			_possibleRegions = 
			$('[ui-region]').each (index, region)=>
				regionName = $(region).attr 'ui-region'
				if _.isEmpty regionName
					regionName = 'dynamicRegion'
				else
					regionName = "#{regionName}Region"
				@_regionManager.addRegion regionName, selector : $(region)
	
			@triggerMethod 'before:start', options
			@_initCallbacks.run options, @
			@triggerMethod 'start', options
	
	
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
			@_identifyRegions()
			@
	
		_identifyRegions : ->
			@$el.find('[ui-region]').each (index, region)=>
				regionName = $(region).attr 'ui-region'
				if _.isEmpty regionName
					regionName = 'dynamicRegion'
				else
					regionName = "#{regionName}Region"
				@addRegion regionName, selector : $(region)
	
			
	
	class Marionette.State extends Backbone.Model
		idAttribute : 'name'
	
		defaults : ->
			ctrl : ''
	
	
	class Marionette.StatesCollection extends Backbone.Collection
		model : Marionette.State
		addState : (name, definition)->
			data = name : name
			_.defaults  data, definition
			@add data
			model = @get name
			if _.isEmpty model.get 'ctrl'
				model.set 'ctrl', "#{@sentenceCase name}Ctrl"
	
		sentenceCase : (name)->
			name.replace /\w\S*/g, (txt)->
				return txt.charAt(0).toUpperCase() + txt.substr(1)
	
	window.statesCollection = new Marionette.StatesCollection
	
	class Marionette.AppStates extends Backbone.Router
	
		constructor : (options = {})->
			super options
			@appStates = Marionette.getOption @, 'appStates'
			_.map @appStates, (stateDef, stateName)->
				statesCollection.addState stateName, stateDef
	
	# 		@processStates @appStates
	# 		@on 'route', @_processState, @
	
	# 	_processState : (args...)->
	# 		window.LoginCtrl.call(args)
	
	# 	processStates : (states)->
	# 		_.each states, (stateDef, stateName)=>
	# 			@route stateDef['url'], stateName
	
	# 	_stateCallback : (args...)->
	# 		true
	
	
	Marionette.State
