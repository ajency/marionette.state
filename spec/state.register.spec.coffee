describe 'Registering a state with Backbone.Router', ->
	
	afterEach ->
			statesCollection.set []

	beforeEach ->
		@routeSpy = spyOn(Backbone.Router::, 'route').and.callThrough()
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

		@states = new States
		@state1 = statesCollection.get 'stateOne'
		@state2 = statesCollection.get 'stateTwo'
		@state3 = statesCollection.get 'stateThree'
		@state4 = statesCollection.get 'stateFour'

	it 'must call Backbone.Router.onRoute function', ->
		expect(@routeSpy).toHaveBeenCalledWith @state1.get('computed_url'), 'stateOne', jasmine.any Function
		expect(@routeSpy).toHaveBeenCalledWith @state4.get('computed_url'), 'stateFour', jasmine.any Function


describe 'process a state on route event',->

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
		@router = new States
		spyOn(Marionette.AppStates::,'_processState').and.callThrough()
		Backbone.history.start()
		@router.navigate '/stateOneUrl/someurl/:id', true

	it 'must call _processState with args', ->
		expect(@router._processState).toHaveBeenCalled()
