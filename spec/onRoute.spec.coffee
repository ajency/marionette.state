describe 'Process a state onRoute event',->

	beforeEach ->
		setFixtures sandbox()
		States = Marionette.AppStates.extend
						appStates : 
							'stateOne' : 
								url : '/stateOneUrl'
							'stateTwo' : 
								url : '/stateTwoUrl'
								parent : 'stateOne'

		spyOn(States::,'_processOnRouteState')

		@router = new States app : new Marionette.Application
		Backbone.history.start()
		@router.navigate '/stateOneUrl/stateTwoUrl', true

	afterEach ->
		statesCollection.set []

	it 'must call _processOnRouteState with args', ->
		expect(@router._processOnRouteState).toHaveBeenCalled()
		expect(-> @router._processOnRouteState 'stateOne' ).toThrow()