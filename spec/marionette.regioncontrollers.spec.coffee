describe 'Marionette.RegionControllers', ->

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
