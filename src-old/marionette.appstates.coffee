class StateChangeEvent extends Marionette.Object

	initialize : (options = {})->
		{app} = options
		@_stopTransition = false

	preventDefault : ()->
		@_stopTransition = true

	_shouldStop : ->
		@_stopTransition is true

class Marionette.AppStates extends Backbone.Router

	constructor : (options = {})->
		super options

		app = options.app

		if app instanceof Marionette.Application isnt true
			throw new Marionette.Error
					message : 'Application instance needed'

		@_app  = app
		@_statesCollection = statesCollection

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
		getParentState = (state)=>
			if state instanceof Marionette.State isnt true
				throw Error 'Not a valid state'

			parentState	= @_statesCollection.get state.get 'parent'
			parentStates.push parentState
			if parentState.isChildState()
				getParentState parentState

		getParentState childState

		parentStates


	_processStateOnRoute : (name, args = [])->
		args.pop()
		_app = @_app

		# create new StateChangeEvent
		event = new StateChangeEvent app : @_app
		@_app.triggerMethod 'state:transition:start', event, name, args

		if event._shouldStop()
			return false

		stateModel = @_statesCollection.get name
		statesToProcess = @_getStatesToProcess stateModel, args

		currentStateProcessor = Marionette.Deferred()
		currentStateProcessor.done (processor)=>
			@_app.triggerMethod 'state:transition:complete', processor
		.fail (error)=>
			@_app.triggerMethod 'state:transition:error', error

		processState = (index, regionContainer)->

			if regionContainer instanceof Marionette.Application is true
				_regionHolder = regionContainer
				_parentCtrl = false
			else
				_regionHolder = regionContainer._view
				_parentCtrl = regionContainer

			stateData = statesToProcess[index]

			processor = new Marionette.StateProcessor
								state : stateData.state
								regionContainer : _regionHolder
								stateParams : stateData.params
								parentCtrl : _parentCtrl

			promise = processor.process()
			promise.done (ctrl)->
				if ctrl instanceof Marionette.RegionController isnt true
					currentStateProcessor.resolve processor
					return

				if index is statesToProcess.length - 1
					currentStateProcessor.resolve processor

				if index < statesToProcess.length - 1
					index++
					processState index, ctrl

		processState 0, @_app

		currentStateProcessor.promise()

	_getStatesToProcess : (stateModel, args)->
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

		statesToProcess












