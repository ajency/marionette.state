class Marionette.AppStates extends Backbone.Router

	constructor : (options = {})->
		super options

		@appStates = Marionette.getOption @, 'appStates'
		@processStates @appStates
		@on 'route', @_processState, @


	_processRoute : (name, args)->
		console.log name, args

	processStates : (states)->
		_.each states, (state)->
			console.log state
