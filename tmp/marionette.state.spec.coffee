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



	# describe 'on construction of object', ->
	# 	it 'must throw error if region not passed', ->
	# 		expect( -> new Marionette.RegionController() ).toThrow()
	# 		expect( -> new Marionette.RegionController region : 'not a region object' ).toThrow()

	# 	it 'must have the unique id', ->
	# 		regionCtrl = new Marionette.RegionController region : _region
	# 		expect(regionCtrl._ctrlID).toBeDefined()

	# 	it 'must have the region object assigned to region property', ->
	# 		regionCtrl = new Marionette.RegionController region : _region
	# 		expect(regionCtrl._region).toBe _region


	# describe "showing a view in region", ->

	# 	beforeEach ->
	# 		setFixtures sandbox()
	# 		@sandboxRegion =  new Marionette.Region el : '#sandbox'
	# 		@ctrl  = new Marionette.RegionController region : @sandboxRegion

	# 	it 'must throw if view is not passed', ->
	# 		expect(-> @ctrl.show() ).toThrow()

	# 	it 'must show view inside the region', ->
	# 		view  = new Marionette.ItemView 'template' : 'My View'
	# 		@ctrl.show view
	# 		expect(@sandboxRegion.currentView).toBe view

