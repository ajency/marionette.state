afterEach ->
	window.location.hash = ''
	Backbone.history.stop()
	Backbone.history.handlers.length = 0

window['StateOneCtrl'] = Marionette.Controller.extend()
window['StateFourCtrl'] = Marionette.Controller.extend()
