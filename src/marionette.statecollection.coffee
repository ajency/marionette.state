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