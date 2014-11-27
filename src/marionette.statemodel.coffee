
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
