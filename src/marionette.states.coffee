
class Marionette.State extends Backbone.Model
	idAttribute : 'name'

	defaults : ->
		ctrl : ''


class Marionette.StatesCollection extends Backbone.Collection
	model : Marionette.State
	addState : (name, definition)->
		data = name : name
		_.defaults  data, definition
		@add data
		model = @get name
		if _.isEmpty model.get 'ctrl'
			model.set 'ctrl', "#{@sentenceCase name}Ctrl"

	sentenceCase : (name)->
		name.replace /\w\S*/g, (txt)->
			return txt.charAt(0).toUpperCase() + txt.substr(1)

window.statesCollection = new Marionette.StatesCollection

class Marionette.AppStates extends Backbone.Router

	constructor : (options = {})->
		super options
		@appStates = Marionette.getOption @, 'appStates'
		_.map @appStates, (stateDef, stateName)->
			statesCollection.addState stateName, stateDef

# 		@processStates @appStates
# 		@on 'route', @_processState, @

# 	_processState : (args...)->
# 		window.LoginCtrl.call(args)

# 	processStates : (states)->
# 		_.each states, (stateDef, stateName)=>
# 			@route stateDef['url'], stateName

# 	_stateCallback : (args...)->
# 		true
