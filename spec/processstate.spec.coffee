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

		@router = new States
		Backbone.history.start()
		@router.navigate '/stateOneUrl/someurl/100', true

	afterEach ->
		window.location.hash = ''
		Backbone.history.stop()
		Backbone.history.handlers.length = 0


	it 'must call _processState with args', ->
		expect(@router._processState).toHaveBeenCalled()

describe 'When processing state with no parent', ->

	beforeEach ->
		
		spyOn(window, 'StateOneCtrl')
		States = Marionette.AppStates.extend
					appStates : 
						'stateOne' : 
							url : '/stateOneUrl'

		@router = new States
		Backbone.history.start()
		@router.navigate '/stateOneUrl', true
		@state1 = statesCollection.get 'stateOne'

	afterEach ->
		window['StateOneCtrl'] = Marionette.Controller.extend()

	it 'must make the state active', ->
		expect(@state1.isActive()).toBe true

	it 'must run StateOneCtrl controller', ->
		expect(window.StateOneCtrl).toHaveBeenCalled()

















