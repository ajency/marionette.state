afterEach ->
	window.location.hash = ''
	Backbone.history.stop()
	Backbone.history.handlers.length = 0

window.RegionControllers = {}
window.RegionControllers['StateOneCtrl'] = Marionette.Controller.extend()
window.RegionControllers['StateTwoCtrl'] = Marionette.Controller.extend()
window.RegionControllers['StateThreeCtrl'] = Marionette.Controller.extend()
window.RegionControllers['StateFourCtrl'] = Marionette.Controller.extend()
window.RegionControllers['State1Ctrl'] = Marionette.Controller.extend()
window.RegionControllers['State2Ctrl'] = Marionette.Controller.extend()
window.RegionControllers['StateLeftCtrl'] = Marionette.Controller.extend()
