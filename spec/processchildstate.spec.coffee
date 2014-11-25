describe 'Process a child state',->

	beforeEach ->
		setFixtures '<div ui-region></div>'
		@app = new Marionette.Application
		@app.addRegions
			dynamicRegion : $('[ui-region]')

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
								parent : 'stateThree'
								views : 
									'region1@stateThree' : ctrl : 'State1Ctrl'
									'region2@stateThree' : ctrl : 'State2Ctrl'

		@router = new States app : @app

	afterEach ->
		@router = null
		Backbone.history.stop()
		statesCollection.set []

	describe 'when processing child state without views', ->

		beforeEach ->
			spyOn(window, 'StateOneCtrl')
			Backbone.history.start()
			@router.navigate '/stateOneUrl/stateTwoUrl/stateThreeUrl', true

		it 'must run parent state first', ->
			expect(window.StateOneCtrl).toHaveBeenCalled()

