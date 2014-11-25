afterEach ->
	window.location.hash = ''
	Backbone.history.stop()
	Backbone.history.handlers.length = 0

window['StateOneCtrl'] = Marionette.Controller.extend()
window['StateTwoCtrl'] = Marionette.Controller.extend()
window['StateThreeCtrl'] = Marionette.Controller.extend()
window['StateFourCtrl'] = Marionette.Controller.extend()
window['State1Ctrl'] = Marionette.Controller.extend()
window['State2Ctrl'] = Marionette.Controller.extend()
