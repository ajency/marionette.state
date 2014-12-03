class Marionette.StateCollection extends Backbone.Collection

	model : Marionette.State

	addState : (name, definition = {})->
		data = name : name
		_.defaults  data, definition
		@add data


window.statesCollection = new Marionette.StateCollection
