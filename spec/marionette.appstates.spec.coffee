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
					@routeSpy = spyOn(Backbone.Router::, 'route').and.callThrough()
					@myStates = new MyStates app : @app

				it 'must call statesCollection.addState', ->
					expect(window.statesCollection.addState).toHaveBeenCalledWith "stateName" , url : '/someurl'

				it 'must have 2 states in collection', ->
					expect(window.statesCollection.length).toBe 2

				describe 'Registering states with backbone router', ->

					it 'must call .route() with path and state name', ->
						expect(@routeSpy).toHaveBeenCalledWith 'statenameurl', 'stateName2'
						expect(@routeSpy).toHaveBeenCalledWith 'someurl', 'stateName'







