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
		stateModel = @_statesCollection.get name
		processor = new Marionette.StateProcessor
										state : stateModel
										app : @_app
										stateParams : args
		processor.process()
		processor
