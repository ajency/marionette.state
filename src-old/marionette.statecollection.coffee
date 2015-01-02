class StateCollection extends Backbone.Collection

	model : Marionette.State

	addState : (name, definition = {})->
		data = name : name
		_.defaults  data, definition
		@add data


statesCollection = new StateCollection
