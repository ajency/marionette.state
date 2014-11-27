describe 'Marionette.RegionControllers', ->

	describe 'Lookup place for controllers', ->

		afterEach ->
			Marionette.RegionControllers::controllers = {}

	  	describe 'When the object is defined', ->

	  	  	beforeEach ->
	  			Marionette.RegionControllers::setLookup window

		  	it 'must be define', ->
	  			expect(Marionette.RegionControllers::controllers).toEqual window

	  	describe 'When the object is not defined', ->

	  		it 'must throw', ->
	  			expect(-> Marionette.RegionControllers::setLookup xooma ).toThrow()



	describe 'when getting a region controller', ->

		describe 'when controller exists', ->

			beforeEach ->
				Marionette.RegionControllers::controllers =
										'LoginCtrl' : Marionette.RegionController.extend()

			it 'must not throw an error', ->
				expect( -> Marionette.RegionControllers::getRegionController 'LoginCtrl').not.toThrow()

		describe 'when controller is not present', ->
			it 'must throw an error', ->
				expect( -> Marionette.RegionControllers::getRegionController 'NoCtrl').toThrow()
