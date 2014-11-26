describe 'Marionette.State', ->

	describe 'when initializing the State', ->

		describe 'when state name is not pased', ->

			it 'must throw an error', ->
				expect(-> new Marionette.State).toThrow()

		describe 'when state name is passed', ->

			beforeEach ->
				@state = new Marionette.State 'name' : 'stateName'

			it 'must have state name as ID', ->
				expect(@state.id).toBe 'stateName'

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



