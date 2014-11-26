describe 'Marionette.RegionController', ->

	describe 'when initializing the region controller', ->

		describe 'when region is not passed', ->

			it 'must throw an error', ->
				expect( -> new Marionette.RegionController ).toThrow()

		describe 'when region instance is passed', ->

			beforeEach ->
				setFixtures sandbox()
				@_region = new Marionette.Region el : '#sandbox'
				@regionCtrl = new Marionette.RegionController region : @_region

			it 'must have a unique controllerid', ->
				expect(@regionCtrl._ctrlID).toBeDefined()

			it 'must have _region property', ->
			  	expect(@regionCtrl._region).toEqual @_region



	# describe 'on construction of object', ->
	# 	it 'must throw error if region not passed', ->
	# 		expect( -> new Marionette.RegionController() ).toThrow()
	# 		expect( -> new Marionette.RegionController region : 'not a region object' ).toThrow()

	# 	it 'must have the unique id', ->
	# 		regionCtrl = new Marionette.RegionController region : _region
	# 		expect(regionCtrl._ctrlID).toBeDefined()

	# 	it 'must have the region object assigned to region property', ->
	# 		regionCtrl = new Marionette.RegionController region : _region
	# 		expect(regionCtrl._region).toBe _region


	# describe "showing a view in region", ->

	# 	beforeEach ->
	# 		setFixtures sandbox()
	# 		@sandboxRegion =  new Marionette.Region el : '#sandbox'
	# 		@ctrl  = new Marionette.RegionController region : @sandboxRegion

	# 	it 'must throw if view is not passed', ->
	# 		expect(-> @ctrl.show() ).toThrow()

	# 	it 'must show view inside the region', ->
	# 		view  = new Marionette.ItemView 'template' : 'My View'
	# 		@ctrl.show view
	# 		expect(@sandboxRegion.currentView).toBe view
