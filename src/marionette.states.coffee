
class Marionette.State extends Backbone.Model

	idAttribute : 'name'

	defaults : ->
		ctrl : ''
		parent : false
		status : 'inactive'

	isActive : ->
		@get('status') is 'active'


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
		@appStates = Marionette.getOption @, 'appStates'
		states = []
		_.map @appStates, (stateDef, stateName)->
			states.push statesCollection.addState stateName, stateDef

		_.each states, (state)->
			@route state.get('computed_url'), state.get('name'), -> return true
		, @

		@on 'route', @_processState, @

	_processState : (name, args)->
		stateModel = window.statesCollection.get name
		stateModel.set 'status', 'active'

		# get controller
		ctrl = stateModel.get 'ctrl'
		if not _.isUndefined window[ctrl]
			new window[ctrl]





