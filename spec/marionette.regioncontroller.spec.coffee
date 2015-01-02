describe 'Marionette.RegionController', ->

	beforeEach ->
		setFixtures sandbox()
		@region = new Marionette.Region el : '#sandbox'
	  
	it 'must be defined',->
		expect(Marionette.RegionController).toBeDefined()

	describe 'when initializing the controller', ->

		beforeEach ->
			@noRegionOptions = {}
			@withRegionOption = region : @region

		describe 'when region instance is not passed', ->
			it 'must throw an error', ->
				expect(-> new Marionette.RegionController(@noRegionOptions)).toThrow()
		  
		describe 'when region instance is passed', ->
			
			beforeEach ->
				@ctrl = new Marionette.RegionController @withRegionOption
			  
			it 'getRegion() must return the region', ->
				expect(@ctrl.getRegion()).toEqual @region

	describe 'when initializing with parent controller', ->

		beforeEach ->
			_region = new Marionette.Region el : 'body'
			@parentCtrl = new Marionette.RegionController region : _region
			@ctrl = new Marionette.RegionController 
										region : @region
										parent : @parentCtrl

		it 'parent() must return the parent controller', ->
			expect(@ctrl.parent()).toEqual @parentCtrl
		  

	describe 'when initializing with state parameters', ->

		beforeEach ->
			@stateParams = [1,2]
			@ctrl = new Marionette.RegionController 
										region : @region
										stateParams : @stateParams

		it 'getParams() must return state parameters', ->
			expect(@ctrl.getParams()).toEqual @stateParams


	describe 'when showing the view inside region', ->

		beforeEach ->
			@view = new Marionette.ItemView template : '<p>template</p>'
			@ctrl = new Marionette.RegionController region : @region
			@spy = spyOn @ctrl, 'triggerMethod'
			@ctrl.show @view

		it 'getCurrentView() must return the view instance', ->
			expect(@ctrl.getCurrentView()).toEqual @view

		it 'must trigger \'view:show\' event on view show ', ->
			expect(@spy).toHaveBeenCalledWith 'view:show', @view

	describe 'when destroying the controller', ->
		
		beforeEach ->
			@view = new Marionette.ItemView template : '<p>template</p>'
			@ctrl = new Marionette.RegionController region : @region
			@ctrl.show @view
			@ctrl.destroy()

		it 'must not have _region, _stateParams, _currentView, _parent', ->
			expect(@ctrl._region).toBeUndefined()
			expect(@ctrl._parent).toBeUndefined()
			expect(@ctrl._stateParams).toBeUndefined()
			expect(@ctrl._currentView).toBeUndefined()
	  

		  
	  
		  


		  
	  