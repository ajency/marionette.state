describe 'Marionette.StateProcessor', ->

	beforeEach ->
		@state = statesCollection.addState 'stateOne'
		Marionette.RegionControllers::controllers =
										'StateOneCtrl' : Marionette.RegionController.extend()

	afterEach ->
		Marionette.RegionControllers::controllers = {}

	describe 'When initializing the StateProcessor', ->

		describe 'when initializing without statemodel', ->

			it 'must throw ', ->
				expect(-> new Marionette.StateProcessor ).toThrow()

		describe 'When initializing with statemodel', ->

		  	beforeEach ->
		  		@stateProcessor = new Marionette.StateProcessor state : @state

		  	it 'must not throw', ->
		  		expect(=> new Marionette.StateProcessor state : @state ).not.toThrow()

		  	it 'must have _state property', ->
		  		expect(@stateProcessor._state).toEqual @state

		  	it 'must have deffered object', ->
		  		expect(@stateProcessor._deffered.done).toEqual jasmine.any Function

	  	describe 'When processing a state', ->

	  		beforeEach ->
	  			setFixtures '<div ui-region></div>'
	  			@app = new Marionette.Application
	  			@app.dynamicRegion = new Marionette.Region el : $('[ui-region]')
	  			@stateProcessor = new Marionette.StateProcessor state : @state
	  			@stateProcessor.process()

	  		it 'must have _ctrlClass defined', ->
	  			_ctrlClass = Marionette.RegionControllers::controllers['StateOneCtrl']
	  			expect(@stateProcessor._ctrlClass).toEqual _ctrlClass

	  		it 'must have _region defined', ->
	  			expect(@stateProcessor._region).toEqual @app.dynamicRegion




