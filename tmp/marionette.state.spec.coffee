afterEach ->
	window.statesCollection.set []
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

describe 'Marionette.State', ->

	describe 'when initializing the State', ->

		describe 'when state name is not pased', ->

			it 'must throw an error', ->
				expect(-> new Marionette.State).toThrow()

		describe 'when state name is passed', ->

			beforeEach ->
				@state = new Marionette.State 'name' : 'stateName'

			it 'must have state name as ID', ->
				expect(@state.id).toBe 'stateName'

			it 'must have the url property', ->
				expect(@state.get 'url').toBe '/stateName'

			it 'must have the parent property', ->
				expect(@state.get 'parent').toEqual false

			it 'must have the computed_url property', ->
				expect(@state.get 'computed_url').toBe 'stateName'

			it 'must have the url_to_array property', ->
				expect(@state.get 'url_to_array').toEqual ['/stateName']

			it 'must have the status property', ->
				expect(@state.get 'status').toBe 'inactive'

			it 'must have the ctrl property', ->
				expect(@state.get 'ctrl').toBe 'StateNameCtrl'

		describe 'when full options are passed', ->

			beforeEach ->
				@state = new Marionette.State
								'name' : 'stateName'
								'url' : '/customUrl'
								'ctrl' : 'MyCustomCtrl'
								'parent' : 'parentState'

			it 'must have state name as ID', ->
				expect(@state.id).toBe 'stateName'

			it 'must have the url property', ->
				expect(@state.get 'url').toBe '/customUrl'

			it 'must have the computed_url property', ->
				expect(@state.get 'computed_url').toBe 'customUrl'

			it 'must have the parent property', ->
				expect(@state.get 'parent').toEqual 'parentState'

			it 'must have the url_to_array property', ->
				expect(@state.get 'url_to_array').toEqual ['/customUrl']

			it 'must have the status property', ->
				expect(@state.get 'status').toBe 'inactive'

			it 'must have the ctrl property', ->
				expect(@state.get 'ctrl').toBe 'MyCustomCtrl'




describe 'Application StateCollection', ->

	it 'window.statesCollection must be defined', ->
		expect(window.statesCollection).toEqual jasmine.any Marionette.StateCollection


describe 'Marionette.StateCollection', ->

	it 'must have Marionette.State as its model', ->
		expect(Marionette.StateCollection::model).toEqual Marionette.State

	describe 'Adding states', ->

		beforeEach ->
			@collection = new Marionette.StateCollection
			states  =
				'someState' : false
				'login' : url : '/login'
				'forgot-password':
					url : '/forgot-password'
					ctrl : 'ForgotPwdCtrl'
				'register' : url : '/register'

			_.each states, (def, name) => @collection.addState name, def

		afterEach ->
			@collection.set []

		it 'must add the states to collection', ->
			expect(@collection.length).toBe 4

		it 'all states must have name and url property',->
			@collection.each (state)->
				expect(state.has 'name').toBe true
				expect(state.has 'url').toBe true

describe 'Maroinette.AppStates', ->

	describe 'When initializing without the application object', ->

		it 'must throw ', ->
			expect(-> new Marionette.AppStates ).toThrow()

	describe 'When initializing with application object', ->

		beforeEach ->
			@app = new Marionette.Application
			spyOn(Marionette.AppStates::, '_registerStates').and.callThrough()
			spyOn(Marionette.AppStates::, 'on').and.callThrough()
			@appStates = new Marionette.AppStates app : @app

		it 'must have _app property', ->
			expect(@appStates._app).toEqual @app

		it 'must call _registerStates', ->
			expect(@appStates._registerStates).toHaveBeenCalled()

		it 'must reference the global statesCollection', ->
			expect(@appStates._statesCollection).toEqual window.statesCollection

		it 'must listen to "route" event',->
			expect(@appStates.on).toHaveBeenCalledWith 'route', @appStates._processStateOnRoute, @appStates

		describe 'Registering States', ->

			describe 'register state with no name ""', ->

				beforeEach ->
					MyStates = Marionette.AppStates.extend
									appStates :
										"" : url : '/someurl'

				it 'must throw error', ->
					_app = @app
					expect(-> new MyStates app : _app).toThrow()

			describe 'Register state with valid definition', ->

				beforeEach ->
					MyStates = Marionette.AppStates.extend
									appStates :
										"stateName" : url : '/someurl'
										"stateName2" : url : '/statenameurl'

					spyOn(window.statesCollection, 'addState').and.callThrough()
					spyOn(MyStates::, '_processStateOnRoute').and.callThrough()
					@routeSpy = spyOn(Backbone.Router::, 'route').and.callThrough()
					@myStates = new MyStates app : @app

				it 'must call statesCollection.addState', ->
					expect(window.statesCollection.addState).toHaveBeenCalledWith "stateName" , url : '/someurl'

				it 'must have 2 states in collection', ->
					expect(window.statesCollection.length).toBe 2

				describe 'Registering states with backbone router', ->

					it 'must call .route() with path and state name', ->
						expect(@routeSpy).toHaveBeenCalledWith 'statenameurl', 'stateName2', jasmine.any Function
						expect(@routeSpy).toHaveBeenCalledWith 'someurl', 'stateName', jasmine.any Function

				describe 'When router triggers route event', ->
					beforeEach ->
						@myStates.trigger 'route', 'stateName', []

					it 'must run _processStateOnRoute function', ->
						expect(@myStates._processStateOnRoute).toHaveBeenCalledWith 'stateName', []












