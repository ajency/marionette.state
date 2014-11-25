afterEach ->
	window.location.hash = ''
	Backbone.history.stop()
	Backbone.history.handlers.length = 0

describe 'Marionette.Application on before start', ->

	app = null
	beforeEach ->
		setFixtures '<div ui-region>Region</div><div ui-region="named">Region</div>'
		app = new Marionette.Application
		app.start()

	it 'must identify regions based on ui-region ', ->
		expect(app.dynamicRegion).toEqual jasmine.any Marionette.Region
		expect(app.namedRegion).toEqual jasmine.any Marionette.Region


describe 'Marionette.LayoutView on render', ->

	layoutView = null
	beforeEach ->
		class LV extends Marionette.LayoutView
			template : '<div>
							<div ui-region>Region</div>
							<div ui-region="named">Region named</div>
						</div>'

		layoutView = new LV
		layoutView.render()
		
	it 'must identify regions based on ui-region', ->
		expect(layoutView.dynamicRegion).toEqual jasmine.any Marionette.Region
		expect(layoutView.namedRegion).toEqual jasmine.any Marionette.Region


describe 'Marionette.States', ->

	afterEach ->
			statesCollection.set []

	describe 'States collection', ->

		it 'must exists', ->
			expect(window.statesCollection).toEqual jasmine.any Marionette.StatesCollection

	describe 'adding states', ->

		beforeEach ->
			spyOn(statesCollection, 'addState').and.callThrough()
			States = Marionette.AppStates.extend
						appStates : 
							'stateName' : 
								url : '/stateUrl'
							'stateTwo' : 
								url : '/stateTwoUrl'
			@states = new States

		
		it 'must run addState on collection', ->
			expect(statesCollection.addState).toHaveBeenCalledWith 'stateName', url : '/stateUrl'

		it 'must create a StateModel instance in collection', ->
			expect(statesCollection.get 'stateName').toEqual jasmine.any Marionette.State

		it 'must have two models in collection', ->
			expect(statesCollection.length).toBe 2

	describe 'state controller', ->

		beforeEach ->
			States = Marionette.AppStates.extend
						appStates : 
							'stateOne' : 
								url : '/stateOneUrl'
							'stateTwo' : 
								url : '/stateTwoUrl'
								ctrl : 'CustomCtrl'
								
			@states = new States
			@state1 = statesCollection.get 'stateOne'
			@state2 = statesCollection.get 'stateTwo'

		it 'must have controller property defined even if not specified', ->
			expect(@state1.has 'ctrl').toBeTruthy()
			expect(@state1.get 'ctrl').toEqual 'StateOneCtrl'

		it 'must override the default behavior if ctrl is provided', ->
			expect(@state2.get 'ctrl').toEqual 'CustomCtrl'

	describe 'state computed url', ->

		beforeEach ->
			States = Marionette.AppStates.extend
						appStates : 
							'stateOne' : 
								url : '/stateOneUrl'
							'stateTwo' : 
								url : '/stateTwoUrl'
								parent : 'stateOne'
							'stateThree' : 
								url : '/stateThreeUrl'
								parent : 'stateTwo'
							'stateFour' : 
								url : '/someurl/:id'
								parent : 'stateOne'

			@states = new States
			@state1 = statesCollection.get 'stateOne'
			@state2 = statesCollection.get 'stateTwo'
			@state3 = statesCollection.get 'stateThree'
			@state4 = statesCollection.get 'stateFour'

		it 'must append to parent url to generate state url', ->
			expect(@state1.get 'computed_url').toBe '/stateOneUrl'
			expect(@state2.get 'computed_url').toBe '/stateOneUrl/stateTwoUrl'
			expect(@state3.get 'computed_url').toBe '/stateOneUrl/stateTwoUrl/stateThreeUrl'
			expect(@state4.get 'computed_url').toBe '/stateOneUrl/someurl/:id'

	
	describe 'state url array', ->

		beforeEach ->
			States = Marionette.AppStates.extend
						appStates : 
							'stateOne' : 
								url : '/stateOneUrl'
							'stateTwo' : 
								url : '/stateTwoUrl'
								parent : 'stateOne'
							'stateThree' : 
								url : '/stateThreeUrl'
								parent : 'stateTwo'

			@states = new States
			@state1 = statesCollection.get 'stateOne'
			@state2 = statesCollection.get 'stateTwo'
			@state3 = statesCollection.get 'stateThree'

		it 'must append to parent url to generate state url', ->
			expect(@state1.get('url_array')).toEqual ['/stateOneUrl']
			expect(@state2.get 'url_array').toEqual ['/stateOneUrl','/stateTwoUrl']
			expect(@state3.get 'url_array').toEqual ['/stateOneUrl','/stateTwoUrl','/stateThreeUrl']
