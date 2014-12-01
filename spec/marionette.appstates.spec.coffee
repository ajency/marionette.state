describe 'Maroinette.AppStates', ->

	beforeEach ->
		@app = new Marionette.Application
		@inValidStates = "" : url : '/someurl'
		@validStates =
				"stateName" : url : '/someurl'
				"stateName2" : url : '/statenameurl/:id'
				"stateName3" : url : '/statename3', parent : 'stateName2'
				"stateName4" : url : '/statename4/:id', parent : 'stateName3'

	afterEach ->
		@app = null



	describe 'When initializing without the application object', ->
		it 'must throw ', ->
			expect(-> new Marionette.AppStates ).toThrow()

	describe 'When initializing with application object', ->
		beforeEach ->
			@app = new Marionette.Application
			spyOn(Marionette.AppStates::, '_registerStates').and.stub()
			spyOn(Marionette.AppStates::, 'on').and.stub()
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
			@MyStates = Marionette.AppStates.extend appStates : @validStates
			spyOn(window.statesCollection, 'addState').and.callThrough()
			@routeSpy = spyOn(Backbone.Router::, 'route').and.callThrough()
			@myStates = new @MyStates app : @app
			@childState = statesCollection.get 'stateName4'
			@parentStates = @myStates._getParentStates @childState

		it 'must return the array of parent states', ->
			expect(@parentStates.length).toEqual 2
			#expect(@parentStates).toEqual [jasmine.any(Marionette.State)]


	describe 'Registering states with backbone router', ->
		beforeEach ->
			@MyStates = Marionette.AppStates.extend appStates : @validStates
			spyOn(window.statesCollection, 'addState').and.callThrough()
			@routeSpy = spyOn(Backbone.Router::, 'route').and.callThrough()
			@myStates = new @MyStates app : @app
			@childState = statesCollection.get 'stateName4'

		it 'must call .route() with path and state name', ->
			expect(@routeSpy).toHaveBeenCalledWith 'statenameurl/:id', 'stateName2', jasmine.any Function
			expect(@routeSpy).toHaveBeenCalledWith 'someurl', 'stateName', jasmine.any Function

	describe 'When processing a state', ->
		beforeEach ->
			@app = new Marionette.Application
			MyStates = Marionette.AppStates.extend appStates : @validStates
			@states = new MyStates app : @app

		describe 'When the state is not present', ->
			it 'must throw', ->
				expect( -> @states._processStateOnRoute 'stateName6', [1,2]	).toThrow()




































				# xdescribe 'When processing state', ->
				# 	beforeEach ->
				# 		statesCollection.addState 'stateName'
				# 		spyOn(Marionette.StateProcessor::, 'initialize')
				# 		@promise = @myStates._processStateOnRoute 'stateName', [23]
				# 		console.log @promise

				# 	it 'must call state processor with state model and regionContainer object',(done)->
				# 		@promise.done (stateProcessor)->
				# 			expect(stateProcessor.initialize).toHaveBeenCalledWith
				# 								state : jasmine.any Marionette.State
				# 								regionContainer : jasmine.any(Marionette.Application)
				# 								stateParams : [23]
				# 			done()

				# 	xit 'must call process function', ->
				# 		@promise.done (stateProcessor)=>
				# 			expect(@p).toHaveBeenCalled()



				# xdescribe 'When processing a child state', ->

				# 	beforeEach ->
				# 		MyStates = Marionette.AppStates.extend appStates : @validStates
				# 		@myStates = new MyStates app : @app
				# 		spyOn(Marionette.StateProcessor::, 'initialize').and.callThrough()
				# 		spyOn(Marionette.StateProcessor::, 'process').and.callFake ->
				# 			a = Marionette.Deferred()
				# 			a.resolve new Marionette.Object
				# 			a.promise()
				# 		@promise = @myStates._processStateOnRoute 'stateName3', [1,3]
				# 		console.log @promise

				# 	it 'must call Marionette.StateProcessor 3 times',->
				# 		expect(Marionette.StateProcessor::initialize.calls.count()).toBe 2

					# xit 'must call Marionette.StateProcessor in proper sequence 1', (done)->
					# 	state2 = statesCollection.get 'stateName2'
					# 	@promise.always ->
					# 		s = Marionette.StateProcessor::initialize.calls.argsFor(0)
					# 		expect(s).toEqual [
					# 					state : state2
					# 					regionContainer : @app
					# 					stateParams : [1]
					# 			]
					# 		done()

					# xit 'must call Marionette.StateProcessor in proper sequence 2', (done)->
					# 	state3 = statesCollection.get 'stateName3'
					# 	@promise.always ->
					# 		s = Marionette.StateProcessor::initialize.calls.argsFor(1)
					# 		expect(s).toEqual [
					# 				state : state3
					# 				regionContainer : jasmine.any Marionette.View
					# 				stateParams : []
					# 			]
					# 		done()

					# xit 'must call Marionette.StateProcessor in proper sequence 3', (done)->
					# 	state4 = statesCollection.get 'stateName4'
					# 	@promise.always ->
					# 		s = Marionette.StateProcessor::initialize.calls.argsFor(2)
					# 		expect(s).toEqual [
					# 				state : state4
					# 				regionContainer : jasmine.any Marionette.View
					# 				stateParams : [3]
					# 			]
					# 		done()







