afterEach ->
	window.location.hash = ''
	Backbone.history.stop()
	Backbone.history.handlers.length = 0


describe 'Marionette.RegionController', ->

	it 'must be defined',->
		expect(Marionette.RegionController).toBeDefined()
	  


