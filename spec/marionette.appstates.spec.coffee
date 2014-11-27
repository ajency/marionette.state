describe 'Maroinette.AppStates', ->

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
					MyStates = Marionette.AppStates.extend
									appStates :
										"" : url : '/someurl'

				it 'must throw error', ->
					_app = @app
					expect(-> new MyStates app : _app).toThrow()

			describe 'Register state with valid definition', ->

				beforeEach ->
					MyStates = Marionette.AppStates.extend
									appStates :
										"stateName" : url : '/someurl'
										"stateName2" : url : '/statenameurl'

					spyOn(window.statesCollection, 'addState').and.callThrough()
					spyOn(MyStates::, '_processStateOnRoute').and.callThrough()
					@routeSpy = spyOn(Backbone.Router::, 'route').and.callThrough()
					@myStates = new MyStates app : @app

				it 'must call statesCollection.addState', ->
					expect(window.statesCollection.addState).toHaveBeenCalledWith "stateName" , url : '/someurl'

				it 'must have 2 states in collection', ->
					expect(window.statesCollection.length).toBe 2

				describe 'Registering states with backbone router', ->

					it 'must call .route() with path and state name', ->
						expect(@routeSpy).toHaveBeenCalledWith 'statenameurl', 'stateName2', jasmine.any Function
						expect(@routeSpy).toHaveBeenCalledWith 'someurl', 'stateName', jasmine.any Function

				describe 'When router triggers route event', ->
					beforeEach ->
						statesCollection.addState 'stateName'
						statesCollection.addState 'stateName1'
						@myStates.trigger 'route', 'stateName', []
						@myStates.trigger 'route', 'stateName1', [23, 'abc']

					it 'must run _processStateOnRoute function', ->
						expect(@myStates._processStateOnRoute).toHaveBeenCalledWith 'stateName', []
						expect(@myStates._processStateOnRoute).toHaveBeenCalledWith 'stateName1', [23, 'abc']

				describe 'When processing route', ->
					beforeEach ->
						statesCollection.addState 'stateName'
						statesCollection.addState 'stateName1'
						spyOn(Marionette.StateProcessor::, 'initialize').and.callThrough()
						@stateProcessor = @myStates._processStateOnRoute 'stateName', []

					it 'must call state processor with state model and application object',->
						expect(@stateProcessor.initialize).toHaveBeenCalledWith
																		state : jasmine.any Marionette.State
																		app : @app

					it 'must have status as pending', ->
						expect(@stateProcessor.getStatus()).toBe 'pending'

