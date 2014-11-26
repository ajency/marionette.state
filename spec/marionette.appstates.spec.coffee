describe 'Maroinette.AppStates', ->

	describe 'When initializing without the application object', ->

		it 'must throw ', ->
			expect(-> new Marionette.AppStates ).toThrow()

	describe 'When initializing with application object', ->

		beforeEach ->
			@app = new Marionette.Application
			spyOn(Marionette.AppStates::, '_registerStates').and.callThrough()
			@appStates = new Marionette.AppStates app : @app

		it 'must have _app property', ->
			expect(@appStates._app).toEqual @app

		it 'must call _registerStates', ->
			expect(@appStates._registerStates).toHaveBeenCalled()

		it 'must reference the global statesCollection', ->
			expect(@appStates._statesCollection).toEqual window.statesCollection

		describe 'Registering States', ->

			describe 'register state with no name ""', ->

				beforeEach ->
					MyStates = Marionette.AppStates.extend
									appStates :
										"" : url : '/someurl'

				it 'must throw error', ->
					_app = @app
					expect(-> new MyStates app : _app).toThrow()

			describe 'register state with valid definition', ->

				beforeEach ->
					MyStates = Marionette.AppStates.extend
									appStates :
										"stateName" : url : '/someurl'
										"stateName2" : url : '/statenameurl'

					spyOn(window.statesCollection, 'addState')
					@myStates = new MyStates app : @app

				it 'must call statesCollection.addState', ->
					expect(window.statesCollection.addState).toHaveBeenCalled()




