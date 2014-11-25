describe 'Process a state on route event',->

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

		spyOn(States::,'_processState').and.callThrough()

		@router = new States app : new Marionette.Application
		Backbone.history.start()
		@router.navigate '/stateOneUrl/someurl/100', true

	afterEach ->
		window.location.hash = ''
		Backbone.history.stop()
		Backbone.history.handlers.length = 0
		statesCollection.set []

	it 'must call _processState with args', ->
		expect(@router._processState).toHaveBeenCalled()
		expect(-> @router._processState 'stateOne' ).toThrow()

describe 'When processing state with no parent', ->

	beforeEach ->
		setFixtures '<div ui-region></div>'
		@app = new Marionette.Application
		
		spyOn(window, 'StateOneCtrl')
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
		window['StateOneCtrl'] = Marionette.Controller.extend()
		statesCollection.set []


	it 'must make the state active', ->
		expect(@state1.isActive()).toBe true

	it 'must run StateOneCtrl controller', ->
		expect(window.StateOneCtrl).toHaveBeenCalled()

	it 'must run StateOneCtrl with region', ->
		data = 
			region : @app.dynamicRegion
			stateParams : [null]
		expect(window.StateOneCtrl).toHaveBeenCalledWith data


describe 'When processing state with no parent and more then 1 view', ->

	beforeEach ->
		setFixtures '<div ui-region></div><div ui-region="name"></div>'
		@app = new Marionette.Application
		window['SomeCtrl'] =  Marionette.Controller.extend()
		window['SomeNameCtrl'] =  Marionette.Controller.extend()
		spyOn(window, 'SomeCtrl')
		spyOn(window, 'SomeNameCtrl')
		States = Marionette.AppStates.extend
					appStates : 
						'stateOne' : 
							url : '/stateOneUrl'
							views : 
								"" : ctrl : 'SomeCtrl'
								'name' : ctrl : 'SomeNameCtrl'

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
		expect(window.SomeCtrl).toHaveBeenCalledWith data

	it 'must run SomeNameCtrl in app.nameRegion', ->
		data = 
			region : @app.nameRegion
			stateParams : [null]
		expect(window.SomeNameCtrl).toHaveBeenCalledWith data
