describe 'Marionette.State', ->

	describe 'when initializing the State', ->

		describe 'when state name is not pased', ->

			it 'must throw an error', ->
				expect(-> new Marionette.State).toThrow()

		describe 'when state name is passed', ->

			beforeEach ->
				spyOn(Marionette.State::, 'on').and.callThrough()
				@state = new Marionette.State 'name' : 'stateName'

			it 'must listen to "change:parentStates" event', ->
				expect(@state.on).toHaveBeenCalledWith 'change:parentStates', @state._processParentStates

			it 'must have state name as ID', ->
				expect(@state.id).toBe 'stateName'

			it 'must have parentStates as an array', ->
				expect(@state.get 'parentStates').toEqual jasmine.any Array

			it 'must have the url property', ->
				expect(@state.get 'url').toBe '/stateName'

			it 'must have the parent property', ->
				expect(@state.get 'parent').toEqual false

			it 'must have the computed_url property', ->
				expect(@state.get 'computed_url').toBe 'stateName'

			it 'must have the url_to_array property', ->
				expect(@state.get 'url_to_array').toEqual ['/stateName']

			it 'must have the status property', ->
				expect(@state.get 'status').toBe 'inactive'

			it 'must have the ctrl property', ->
				expect(@state.get 'ctrl').toBe 'StateNameCtrl'

		describe 'when full options are passed', ->

			beforeEach ->
				@state = new Marionette.State
								'name' : 'stateName'
								'url' : '/customUrl'
								'ctrl' : 'MyCustomCtrl'
								'parent' : 'parentState'

			it 'must have state name as ID', ->
				expect(@state.id).toBe 'stateName'

			it 'must have the url property', ->
				expect(@state.get 'url').toBe '/customUrl'

			it 'must have the computed_url property', ->
				expect(@state.get 'computed_url').toBe 'customUrl'

			it 'must have the parent property', ->
				expect(@state.get 'parent').toEqual 'parentState'

			it 'must have the url_to_array property', ->
				expect(@state.get 'url_to_array').toEqual ['/customUrl']

			it 'must have the status property', ->
				expect(@state.get 'status').toBe 'inactive'

			it 'must have the ctrl property', ->
				expect(@state.get 'ctrl').toBe 'MyCustomCtrl'

	describe 'When parentStates property changes', ->

		beforeEach ->
			@parentState1 = new Marionette.State 'name' : 'parentState1'
			@parentState2 = new Marionette.State 'name' : 'parentState2', parent : 'parentState1'
			@state = new Marionette.State 'name' : 'stateName', parent : 'parenState2'
			@state.set 'parentStates', [@parentState2, @parentState1]

		it 'must have computed_url equal to /parentState1/parentState2/stateName', ->
			cUrl = 'parentState1/parentState2/stateName'
			expect(@state.get 'computed_url').toBe cUrl

		it 'must have url_to_array ', ->
			arr = ['/parentState1','/parentState2','/stateName']
			expect(@state.get 'url_to_array').toEqual arr




