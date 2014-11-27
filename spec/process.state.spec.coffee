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

		describe 'When initializing with statemodel and application instance', ->

			beforeEach ->
				@stateProcessor = new Marionette.StateProcessor state : @state, app : @app

			it 'must not throw', ->
				expect(=> new Marionette.StateProcessor state : @state, app : @app ).not.toThrow()

			it 'must have _state property', ->
				expect(@stateProcessor._state).toEqual @state

			it 'must have _deferred object', ->
				expect(@stateProcessor._deferred.done).toEqual jasmine.any Function

			it 'must have application object', ->
				expect(@stateProcessor._app).toEqual @app

		describe 'When processing a state', ->

			beforeEach ->
				class @StateCtrl extends Marionette.RegionController
					initialize : (options = {}) ->

				spyOn(Marionette.RegionControllers::, 'getRegionController').and.returnValue @StateCtrl
				spyOn(@StateCtrl::, 'initialize')
				@app.dynamicRegion = new Marionette.Region el : $('[ui-region]')
				@setCtrlSpy = spyOn(@app.dynamicRegion,'setController')
				@setCtrlParamSpy = spyOn(@app.dynamicRegion,'setControllerStateParams')
				@stateProcessor = new Marionette.StateProcessor state : @state, app : @app
				spyOn(@stateProcessor, 'listenTo').and.callThrough()
				@promise = @stateProcessor.process()

			it 'must have _ctrlClass defined', ->
				expect(@stateProcessor._ctrlClass).toEqual @StateCtrl

			it 'must listen to "view:rendered" event of ctrl instance', ->
				expect(@stateProcessor.listenTo).toHaveBeenCalledWith jasmine.any(Marionette.RegionController), 'view:rendered', @stateProcessor._onViewRendered

			it 'must have _region defined', ->
				expect(@stateProcessor._region).toEqual @app.dynamicRegion

			it 'must run controller with state params', ->
					expect(@StateCtrl::initialize).toHaveBeenCalledWith
																	region : @app.dynamicRegion
																	stateParams : []

			it 'must return the promise', ->
				expect(@promise.done).toEqual jasmine.any Function

			it 'region must store the name of ctrl with params', ->
				expect(@setCtrlSpy).toHaveBeenCalledWith 'StateOneCtrl'
				expect(@setCtrlParamSpy).toHaveBeenCalledWith []


			describe 'when view is rendered in region', ->
				beforeEach ->
					@stateProcessor._ctrlInstance.trigger 'view:rendered', new Marionette.ItemView

				it 'must resovle the state', ->
					expect(@stateProcessor._deferred.state()).toBe 'resolved'


			describe 'when processing state with params', ->

				beforeEach ->
					@paramStateProcessor = new Marionette.StateProcessor
															state : @state
															app : @app
															stateParams : [12]
					@paramStateProcessor.process()

				it 'must store the state params', ->
					expect(@paramStateProcessor._stateParams).toEqual [12]

				it 'must run controller with state params', ->
					expect(@StateCtrl::initialize).toHaveBeenCalledWith
															region : jasmine.any Marionette.Region
															stateParams : [12]




