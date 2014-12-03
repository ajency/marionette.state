describe 'Marionette.StateProcessor', ->

	beforeEach ->
		setFixtures '<div ui-region></div>'
		@app = new Marionette.Application
		@state = statesCollection.addState 'stateOne'
		@paramState = statesCollection.addState 'paramState',
													url : '/paramstate/:id'
													ctrl : 'ParamCtrl'
		Marionette.RegionControllers::controllers =
									'StateOneCtrl' : Marionette.RegionController.extend()

	afterEach ->
		Marionette.RegionControllers::controllers = {}

	describe 'When initializing the StateProcessor', ->

		describe 'when initializing without statemodel and Application instance', ->

			it 'must throw ', ->
				expect(-> new Marionette.StateProcessor ).toThrow()
				expect(=> new Marionette.StateProcessor state : @state).toThrow()

		describe 'When initializing with statemodel and regionContainer instance', ->

			beforeEach ->
				@stateProcessor = new Marionette.StateProcessor
													state : @state
													regionContainer : @app

			it 'must not throw', ->
				expect(=> new Marionette.StateProcessor state : @state, regionContainer : @app ).not.toThrow()

			it 'must have _state property', ->
				expect(@stateProcessor._state).toEqual @state

			it 'must have _deferred object', ->
				expect(@stateProcessor._deferred.done).toEqual jasmine.any Function

			it 'must have regionContainer object', ->
				expect(@stateProcessor._regionContainer).toEqual @app

		describe 'When processing a state', ->

			beforeEach ->
				class @StateCtrl extends Marionette.RegionController
					initialize : (options = {}) ->

				spyOn(Marionette.RegionControllers::, 'getRegionController').and.returnValue @StateCtrl
				spyOn(@StateCtrl::, 'initialize')
				@app.dynamicRegion = new Marionette.Region el : $('[ui-region]')
				@setCtrlSpy = spyOn(@app.dynamicRegion,'setController')
				@setCtrlParamSpy = spyOn(@app.dynamicRegion,'setControllerStateParams')
				@stateProcessor = new Marionette.StateProcessor
														state : @state
														regionContainer : @app

				spyOn(@stateProcessor, 'listenTo').and.callThrough()
				@promise = @stateProcessor.process()

			it 'must have _ctrlClass defined', ->
				expect(@stateProcessor._ctrlClass).toEqual @StateCtrl


