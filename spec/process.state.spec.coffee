describe 'When processing state', ->

	beforeEach ->
		setFixtures '<div ui-region></div>'
		@app = new Marionette.Application
		@app.dynamicRegion =  new Marionette.Region el : $('[ui-region]')
		@CtrlClass = jasmine.createSpy 'StateOneCtrl'
		spyOn(Marionette.RegionControllers::, 'getRegionController').and.returnValue @CtrlClass
		@state1 = new Marionette.State 
							name : 'stateOne'
							ctrl : 'StateOneCtrl'
							url : '/stateOneUrl'
							computed_url : '/stateOneUrl'
							url_to_array : ['/stateOneUrl']
							status : 'inactive'
							parent : false
		statesCollection.add @state1
		spyOn(@state1, 'trigger')
		spyOn(@state1, 'listenTo')
		@router = new Marionette.AppStates app : @app
		@router._processOnRouteState 'stateOne'
		

	afterEach ->
		statesCollection.set []

	it 'must make the state status as processing', ->
		expect(@state1.getStatus()).toBe 'processing'

	it 'must trigger event', ->
		expect(@state1.trigger).toHaveBeenCalledWith "processing:stateOne"		

	it 'must get the region to run ctrl', ->
		expect(@state1.get 'activeRegion').toEqual jasmine.any Marionette.Region

	describe 'running the controller', ->

		it 'must run the controller with region', ->
			data = 
				region : @app.dynamicRegion
				stateParams : []
			expect(@CtrlClass).toHaveBeenCalledWith data

		it 'state must listen to complete event on controller instance',->
			expect(@state.listenTo).toHaveBeenCalledWith jasmine.any(Marionette.Controller), 'complete', jasmine.any Function