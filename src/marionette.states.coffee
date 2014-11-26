class Marionette.RegionControllers

	regionControllersLookup : ->
		if not window.RegionControllers
			window.RegionControllers = {}

		window.RegionControllers

	getRegionController : (name)->
		lookUp = Marionette.RegionControllers::regionControllersLookup()
		if not _.isUndefined lookUp[name]
			return lookUp[name]
		else
			throw new Marionette.Error
							message : 'region controller not found'

class Marionette.State extends Backbone.Model

	idAttribute : 'name'

	defaults : ->
		ctrl : ''
		parent : false
		status : 'inactive'

	isActive : ->
		@get('status') is 'active'

	isChildState : ->
		@get('parent') isnt false


class Marionette.StatesCollection extends Backbone.Collection
	model : Marionette.State
	addState : (name, definition = {})->
		data = name : name
		_.defaults  data, definition
		@add data
		stateModel = @get name

		# controller
		if _.isEmpty stateModel.get 'ctrl'
			stateModel.set 'ctrl', "#{@sentenceCase name}Ctrl"

		# state computed URL
		computedUrl = stateModel.get 'url'
		computeUrl = (state)=>
			parent = state.get 'parent'
			parentState = @get parent
			computedUrl = "#{parentState.get 'url'}#{computedUrl}"
			if false isnt parentState.get 'parent'
				computeUrl parentState

		if false isnt stateModel.get 'parent'
			computeUrl stateModel

		stateModel.set 'computed_url', computedUrl.substring 1 # remove first '/'

		# state URL array
		urlArray = []
		urlArray.push stateModel.get 'url'
		urlToArray = (state)=>
			parent = state.get 'parent'
			parentState = @get parent
			urlArray.push parentState.get 'url'
			if false isnt parentState.get 'parent'
				urlToArray parentState

		if false isnt stateModel.get 'parent'
			urlToArray stateModel

		stateModel.set 'url_array', urlArray.reverse()
		
		stateModel

	sentenceCase : (name)->
		name.replace /\w\S*/g, (txt)->
			return txt.charAt(0).toUpperCase() + txt.substr(1)

window.statesCollection = new Marionette.StatesCollection

class Marionette.AppStates extends Backbone.Router

	constructor : (options = {})->
		super options
		if not options.app or ( options.app instanceof Marionette.Application isnt true)
			throw new Marionette.Error
					message : 'Application instance needed'

		{@app} = options

		@appStates = Marionette.getOption @, 'appStates'
		states = []
		_.map @appStates, (stateDef, stateName)->
			states.push statesCollection.addState stateName, stateDef

		_.each states, (state)->
			@route state.get('computed_url'), state.get('name'), -> return true
		, @

		@on 'route', @_processOnRouteState, @

	_processOnRouteState : (name, args = [])->
		stateModel = window.statesCollection.get name
		if stateModel.isChildState()
			@_processChildState stateModel, args
		else
			@_processState stateModel, args
		
	_processChildState : (stateModel, args)->
		parentState = window.statesCollection.get stateModel.get 'parent'
		@_processOnRouteState parentState.get('name'), args

	_processState : (stateModel, args)->
		stateModel.set 'status', 'active'
		if stateModel.has('views') and false is stateModel.get 'parent' 
			
			views = stateModel.get 'views'
			_.each views, (value, key)=>
				ctrl = value['ctrl']
				ControllerClass = Marionette.RegionControllers::getRegionController ctrl
		
				if key is ''
					_region = @app.dynamicRegion
				else
					_region = @app["#{key}Region"]

				new ControllerClass
					region : _region
					stateParams : args

			return

		# get controller
		ctrl = stateModel.get 'ctrl'
		ControllerClass = Marionette.RegionControllers::getRegionController ctrl

		# get the region to run controller
		if false is stateModel.get('parent') and ( @app.dynamicRegion instanceof Marionette.Region) isnt true
			throw new Marionette.Error
					message : 'Dynamic region not defined for app'

		if false is stateModel.get 'parent' 
			_region = @app.dynamicRegion

		new ControllerClass
				region : _region
				stateParams : args

	





