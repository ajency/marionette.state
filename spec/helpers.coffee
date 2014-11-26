afterEach ->
	window.statesCollection.set []
	window.location.hash = ''
	Backbone.history.stop()
	Backbone.history.handlers.length = 0
