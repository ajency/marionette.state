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
describe 'Marionette.RegionController', ->

	describe 'when initializing the region controller', ->

		describe 'when region is not passed', ->

			it 'must throw an error', ->
				expect( -> new Marionette.RegionController ).toThrow()

		describe 'when region instance is passed', ->

			beforeEach ->
				setFixtures sandbox()
				@_region = new Marionette.Region el : '#sandbox'
				@regionCtrl = new Marionette.RegionController region : @_region

			it 'must have a unique controllerid', ->
				expect(@regionCtrl._ctrlID).toBeDefined()

			it 'must have _region property', ->
				expect(@regionCtrl._region).toEqual @_region

	describe 'when showing the view inside the region', ->

		beforeEach ->
			setFixtures sandbox()
			@_region = new Marionette.Region el : '#sandbox'
			@regionCtrl = new Marionette.RegionController region : @_region

		describe 'when view is not instance of Backbone.View', ->

			it 'must throw an error', ->
				regionCtrl = @regionCtrl
				expect(-> regionCtrl.show('abc')).toThrow()

		describe 'when view instance passed', ->

			beforeEach ->
				spyOn(@_region, 'show')
				@view  = new Marionette.ItemView()
				@regionCtrl.show @view

			it 'must have _view property equal to view', ->
				expect(@regionCtrl._view).toEqual @view

			it 'must run show function on the passed region', ->
				expect(@_region.show).toHaveBeenCalledWith @view

