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
		stateModel = @_statesCollection.get name
		processor = new Marionette.StateProcessor
										state : stateModel
										app : @_app
										stateParams : args
		processor.process()
		processor


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
