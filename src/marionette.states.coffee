class Marionette.AppStates extends Backbone.Router

	constructor : (options = {})->
		super options
		@appStates = Marionette.getOption @, 'appStates'
		@processStates @appStates
		@on 'route', @_processState, @


	_processRoute : (name, args)->
		console.log name, args

	processStates : (states)->
		_.each states, (stateDef, stateName)=>
			@route stateDef['url'], stateName, _.bind @_stateCallback, def : stateDef

	_stateCallback : (args...)->
		console.log @def['url']
