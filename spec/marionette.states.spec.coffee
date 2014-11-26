describe 'region controller lookup', ->
	it 'should throw if region controller lookup is not defined', ->
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


describe 'Marionette.States', ->

	afterEach ->
			statesCollection.set []

	describe 'States collection', ->

		it 'must exists', ->
			expect(window.statesCollection).toEqual jasmine.any Marionette.StatesCollection

	describe 'adding states', ->

		beforeEach ->
			spyOn(statesCollection, 'addState').and.callThrough()
			States = Marionette.AppStates.extend
						appStates : 
							'stateName' : 
								url : '/stateUrl'
							'stateTwo' : 
								url : '/stateTwoUrl'
			@states = new States app : new Marionette.Application

		
		it 'must run addState on collection', ->
			expect(statesCollection.addState).toHaveBeenCalledWith 'stateName', url : '/stateUrl'

		it 'must create a StateModel instance in collection', ->
			expect(statesCollection.get 'stateName').toEqual jasmine.any Marionette.State

		it 'must have two models in collection', ->
			expect(statesCollection.length).toBe 2

	describe 'state controller', ->

		beforeEach ->
			States = Marionette.AppStates.extend
						appStates : 
							'stateOne' : 
								url : '/stateOneUrl'
							'stateTwo' : 
								url : '/stateTwoUrl'
								ctrl : 'CustomCtrl'
								
			@states = new States app : new Marionette.Application
			@state1 = statesCollection.get 'stateOne'
			@state2 = statesCollection.get 'stateTwo'

		it 'must have controller property defined even if not specified', ->
			expect(@state1.has 'ctrl').toBeTruthy()
			expect(@state1.get 'ctrl').toEqual 'StateOneCtrl'

		it 'must override the default behavior if ctrl is provided', ->
			expect(@state2.get 'ctrl').toEqual 'CustomCtrl'

	describe 'state computed url', ->

		beforeEach ->
			States = Marionette.AppStates.extend
						appStates : 
							'stateOne' : 
								url : '/stateOneUrl'
							'stateTwo' : 
								url : '/stateTwoUrl'
								parent : 'stateOne'
							'stateThree' : 
								url : '/stateThreeUrl'
								parent : 'stateTwo'
							'stateFour' : 
								url : '/someurl/:id'
								parent : 'stateOne'

			@states = new States app : new Marionette.Application
			@state1 = statesCollection.get 'stateOne'
			@state2 = statesCollection.get 'stateTwo'
			@state3 = statesCollection.get 'stateThree'
			@state4 = statesCollection.get 'stateFour'

		it 'must append to parent url to generate state url', ->
			expect(@state1.get 'computed_url').toBe 'stateOneUrl'
			expect(@state2.get 'computed_url').toBe 'stateOneUrl/stateTwoUrl'
			expect(@state3.get 'computed_url').toBe 'stateOneUrl/stateTwoUrl/stateThreeUrl'
			expect(@state4.get 'computed_url').toBe 'stateOneUrl/someurl/:id'

	
	describe 'state url array', ->

		beforeEach ->
			States = Marionette.AppStates.extend
						appStates : 
							'stateOne' : 
								url : '/stateOneUrl'
							'stateTwo' : 
								url : '/stateTwoUrl'
								parent : 'stateOne'
							'stateThree' : 
								url : '/stateThreeUrl'
								parent : 'stateTwo'

			@states = new States app : new Marionette.Application
			@state1 = statesCollection.get 'stateOne'
			@state2 = statesCollection.get 'stateTwo'
			@state3 = statesCollection.get 'stateThree'

		it 'must append to parent url to generate state url', ->
			expect(@state1.get 'url_array').toEqual ['/stateOneUrl']
			expect(@state2.get 'url_array').toEqual ['/stateOneUrl','/stateTwoUrl']
			expect(@state3.get 'url_array').toEqual ['/stateOneUrl','/stateTwoUrl','/stateThreeUrl']

	# describe 'state views', ->

	# 	beforeEach ->
	# 		setFixtures '<div ui-region>Region</div>'
	# 		@app = new Marionette.Application
	# 		@app.start()
	# 		States = Marionette.AppStates.extend
	# 					appStates : 
	# 						'state1' : 
	# 							url : '/state1url'
	# 						'state2' : 
	# 							url : '/state2url'
	# 							parent : 'state1'
	# 							views : 
	# 								'@state1' : ctrl : 'SomeCtrl'
	# 								'regionname@state1' : ctrl : 'SomeOtherCtrl'



	# 		@states = new States app : new Marionette.Application
	# 		@state1 = statesCollection.get 'stateOne'

	# 	it 'must have Application dynamic region as its region', ->
	# 		expect(@state1.get 'views').toBe 
