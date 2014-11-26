afterEach ->
	window.location.hash = ''
	Backbone.history.stop()
	Backbone.history.handlers.length = 0
describe 'Marionette.Application', ->

	app = null
	afterEach ->
		app = null
	
	describe 'on before start', ->
	
		beforeEach ->
			setFixtures '<div ui-region>Region</div><div ui-region="named">Region</div>'
			app = new Marionette.Application
			app.start()

		it 'must identify regions based on ui-region attribute', ->
			expect(app.dynamicRegion).toEqual jasmine.any Marionette.Region
			expect(app.namedRegion).toEqual jasmine.any Marionette.Region

	describe 'when dynamic region is not setup', ->
		
		beforeEach ->
			setFixtures '<div ui-region="named">Region</div>'
			app = new Marionette.Application

		it 'ap.start() must throw error', ->
			expect( -> app.start() ).toThrow()
describe 'Marionette.LayoutView', ->

	layoutView = null
	beforeEach ->
		class LV extends Marionette.LayoutView
			template : '<div>
							<div ui-region>Region</div>
							<div ui-region="named">Region named</div>
						</div>'

		layoutView = new LV
		layoutView.render()

	describe 'on render of layout view', ->
		it 'must identify regions based on ui-region', ->
			expect(layoutView.dynamicRegion).toEqual jasmine.any Marionette.Region
			expect(layoutView.namedRegion).toEqual jasmine.any Marionette.Region


describe 'Marionette.RegionControllers', ->

	describe 'when getting a region controller', ->

		describe 'when controller exists', ->
		
			beforeEach ->
				Marionette.RegionControllers::controllers = 
										'LoginCtrl' : Marionette.Controller.extend()

			it 'must not throw an error', ->
				expect( -> Marionette.RegionControllers::getRegionController 'LoginCtrl').not.toThrow()

		describe 'when controller is not present', ->
			it 'must throw an error', ->
				expect( -> Marionette.RegionControllers::getRegionController 'NoCtrl').toThrow()
