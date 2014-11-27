describe 'Maroinette.AppStates', ->

	beforeEach ->
		@inValidStates = "" : url : '/someurl'
		@validStates =
				"stateName" : url : '/someurl'
				"stateName2" : url : '/statenameurl/:id'
				"stateName3" : url : '/statename3/:id', parent : 'stateName2'
				"stateName4" : url : '/statename4/:id', parent : 'stateName3'


	describe 'When initializing without the application object', ->

		it 'must throw ', ->
			expect(-> new Marionette.AppStates ).toThrow()

	describe 'When initializing with application object', ->

		beforeEach ->
			@app = new Marionette.Application
			spyOn(Marionette.AppStates::, '_registerStates').and.callThrough()
			spyOn(Marionette.AppStates::, 'on').and.callThrough()
			@appStates = new Marionette.AppStates app : @app

		it 'must have _app property', ->
			expect(@appStates._app).toEqual @app

		it 'must call _registerStates', ->
			expect(@appStates._registerStates).toHaveBeenCalled()

		it 'must reference the global statesCollection', ->
			expect(@appStates._statesCollection).toEqual window.statesCollection

		it 'must listen to "route" event',->
			expect(@appStates.on).toHaveBeenCalledWith 'route', @appStates._processStateOnRoute, @appStates

		describe 'Registering States', ->

			describe 'register state with no name ""', ->

				beforeEach ->
					MyStates = Marionette.AppStates.extend appStates : @inValidStates
				it 'must throw error', ->
					_app = @app
					expect(-> new MyStates app : _app).toThrow()

			describe 'Register state with valid definition', ->
				beforeEach ->
					@MyStates = Marionette.AppStates.extend appStates : @validStates
					spyOn(window.statesCollection, 'addState').and.callThrough()
					@routeSpy = spyOn(Backbone.Router::, 'route').and.callThrough()
					@myStates = new @MyStates app : @app
					@childState = statesCollection.get 'stateName4'

				it 'must call statesCollection.addState', ->
					expect(window.statesCollection.addState).toHaveBeenCalledWith "stateName" , url : '/someurl'

				describe 'Getting parent states of child state', ->

					beforeEach ->
						@parentStates = @myStates._getParentStates @childState

					it 'must return the array of parent states', ->
						expect(@parentStates.length).toEqual 2
						#expect(@parentStates).toEqual [jasmine.any(Marionette.State)]


				describe 'Registering states with backbone router', ->

					it 'must call .route() with path and state name', ->
						expect(@routeSpy).toHaveBeenCalledWith 'statenameurl/:id', 'stateName2', jasmine.any Function
						expect(@routeSpy).toHaveBeenCalledWith 'someurl', 'stateName', jasmine.any Function

				describe 'When processing route', ->
					beforeEach ->
						statesCollection.addState 'stateName'
						spyOn(Marionette.StateProcessor::, 'initialize')
						spyOn(Marionette.StateProcessor::, 'process')
						@stateProcessor = @myStates._processStateOnRoute 'stateName', [23]

					it 'must call state processor with state model and application object',->
						expect(@stateProcessor.initialize).toHaveBeenCalledWith
															state : jasmine.any Marionette.State
															app : jasmine.any Marionette.Application
															stateParams : [23]

					it 'must call process function', ->
						expect(@stateProcessor.process).toHaveBeenCalled()

