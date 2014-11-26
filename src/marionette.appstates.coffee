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