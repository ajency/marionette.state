describe 'Application StateCollection', ->

	it 'window.statesCollection must be defined', ->
		expect(window.statesCollection).toEqual jasmine.any Marionette.StateCollection


describe 'Marionette.StateCollection', ->

	it 'must have Marionette.State as its model', ->
		expect(Marionette.StateCollection::model).toEqual Marionette.State

	describe 'Adding states', ->

		beforeEach ->
			@collection = new Marionette.StateCollection
			states  =
				'someState' : false
				'login' : url : '/login'
				'forgot-password':
					url : '/forgot-password'
					ctrl : 'ForgotPwdCtrl'
				'register' : url : '/register'

			_.each states, (def, name) => @collection.addState name, def

		afterEach ->
			@collection.set []

		it 'must add the states to collection', ->
			expect(@collection.length).toBe 4

		it 'all states must have name and url property',->
			@collection.each (state)->
				expect(state.has 'name').toBe true
				expect(state.has 'url').toBe true
