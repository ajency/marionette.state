describe 'Process a child state',->

	beforeEach ->
		setFixtures '<div ui-region></div>'
		@app = new Marionette.Application
		@app.addRegions
			dynamicRegion : $('[ui-region]')

		States = Marionette.AppStates.extend
						appStates : 
							'root' : 
								url : ''
								views : 
									'' : ctrl : 'State1Ctrl'
									'left' : ctrl : 'StateLeftCtrl'
							'stateTwo' : 
								url : '/stateTwoUrl'
								parent : 'root'
								views : 
									'@root' : ctrl : 'State2Ctrl'

		@router = new States app : @app

	afterEach ->
		@router = null
		Backbone.history.stop()
		statesCollection.set []

	describe 'when processing child state without views', ->

		beforeEach ->
			spyOn(window, 'StateOneCtrl')
			Backbone.history.start()
			@router.navigate '/stateTwoUrl', true

		it 'must run parent state first', ->
			expect(window.StateOneCtrl).toHaveBeenCalled()

