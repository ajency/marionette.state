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

				it 'must resovle with controller instance', (done)->
					@promise.done (ctrl)->
						expect(ctrl).toEqual jasmine.any Marionette.RegionController
					.always ->
						done()


			describe 'when processing state with params', ->

				beforeEach ->
					@paramStateProcessor = new Marionette.StateProcessor
															state : @state
															regionContainer : @app
															stateParams : [12]
					@paramStateProcessor.process()

				it 'must store the state params', ->
					expect(@paramStateProcessor._stateParams).toEqual [12]

				it 'must run controller with state params', ->
					expect(@StateCtrl::initialize).toHaveBeenCalledWith
															region : jasmine.any Marionette.Region
															stateParams : [12]

		describe 'when the same controller is run again', ->
			beforeEach ->
				@app.dynamicRegion = new Marionette.Region el : $('[ui-region]')
				@paramStateProcessor = new Marionette.StateProcessor
														state : @state
														regionContainer : @app
														stateParams : [12]
				spyOn(Marionette.RegionControllers::,'getRegionController').and.callThrough()

				@paramStateProcessor.process()
				@ctrl = @app.dynamicRegion._ctrlInstance
				spyOn( @ctrl, 'trigger').and.callThrough()
				@paramStateProcessor.process()

			it 'must be called only once', ->
				expect(Marionette.RegionControllers::getRegionController.calls.count()).toEqual 1

			it 'must trigger the view:rendered event on ctlr', ->
				expect(@ctrl.trigger).toHaveBeenCalled()




