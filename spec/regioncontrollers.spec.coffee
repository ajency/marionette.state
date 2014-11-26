describe 'region controller lookup', ->
	it 'must have the lookup defined', ->
		expect( Marionette.RegionControllers::regionControllersLookup()).toEqual jasmine.any Object

describe 'when looking for region controller', ->

	beforeEach ->
		Marionette.RegionController = Marionette.Controller.extend()
		window.RegionControllers = 
					'LoginCtrl' : Marionette.RegionController.extend()
					'NoAccessCtrl' : Marionette.RegionController.extend()
		

	it 'must return controller if present', ->
		Ctrl = Marionette.RegionControllers::getRegionController 'LoginCtrl'
		ctrl = new Ctrl
		expect(ctrl).toEqual jasmine.any Marionette.RegionController

	describe 'when controller is not defined', ->
		it 'must throw', ->
			expect(-> Marionette.RegionControllers::getRegionController 'NoCtrl' ).toThrow()