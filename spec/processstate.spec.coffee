describe 'Process a state on route event',->

	beforeEach ->
		setFixtures sandbox()
		States = Marionette.AppStates.extend
						appStates : 
							'stateOne' : 
								url : '/stateOneUrl'
							'stateTwo' : 
								url : '/stateTwoUrl'
								parent : 'stateOne'

		spyOn(States::,'_processState')

		@router = new States app : new Marionette.Application
		Backbone.history.start()
		@router.navigate '/stateOneUrl/stateTwoUrl', true

	afterEach ->
		statesCollection.set []

	it 'must call _processState with args', ->
		expect(@router._processState).toHaveBeenCalled()
		expect(-> @router._processState 'stateOne' ).toThrow()

describe 'When processing state with no parent', ->

	beforeEach ->
		setFixtures '<div ui-region></div>'
		@app = new Marionette.Application
		@CtrlClass = jasmine.createSpy 'StateOneCtrl'
		spyOn(Marionette.RegionControllers::, 'getRegionController').and.returnValue @CtrlClass
		States = Marionette.AppStates.extend
					appStates : 
						'stateOne' : 
							url : '/stateOneUrl'
		@app.addInitializer =>
			@router = new States app : @app
			Backbone.history.start()
			@router.navigate '/stateOneUrl', true
		@app.start()
		@state1 = statesCollection.get 'stateOne'

	afterEach ->
		statesCollection.set []

	it 'must make the state active', ->
		expect(@state1.isActive()).toBe true

	it 'must run StateOneCtrl controller', ->
		expect(@CtrlClass).toHaveBeenCalled()

	it 'must run StateOneCtrl with region', ->
		data = 
			region : @app.dynamicRegion
			stateParams : [null]
		expect(@CtrlClass).toHaveBeenCalledWith data


describe 'When processing state with no parent and more then 1 view', ->

	beforeEach ->
		setFixtures '<div ui-region></div><div ui-region="name"></div>'
		@app = new Marionette.Application
		@State1Ctrl = jasmine.createSpy 'State1Ctrl'
		@State2Ctrl = jasmine.createSpy 'State2Ctrl'
		spyOn(Marionette.RegionControllers::, 'getRegionController').and.callFake (name)=>
					 @[name]

		States = Marionette.AppStates.extend
					appStates : 
						'stateOne' : 
							url : '/stateOneUrl'
							views : 
								"" : ctrl : 'State1Ctrl'
								'name' : ctrl : 'State2Ctrl'

		@app.addInitializer =>
			@router = new States app : @app
			Backbone.history.start()
			@router.navigate '/stateOneUrl', true

		@app.start()
		@state1 = statesCollection.get 'stateOne'

	afterEach ->
		statesCollection.set []

	it 'must run SomeCtrl in dynamic region', ->
		data = 
			region : @app.dynamicRegion
			stateParams : [null]
		expect(@State1Ctrl).toHaveBeenCalledWith data

	it 'must run SomeNameCtrl in app.nameRegion', ->
		data = 
			region : @app.nameRegion
			stateParams : [null]
		expect(@State2Ctrl).toHaveBeenCalledWith data
