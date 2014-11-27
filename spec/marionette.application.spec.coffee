describe 'Marionette.Application', ->

	app = null
	afterEach ->
		app = null

	describe 'on before start', ->

		beforeEach ->
			setFixtures '<div ui-region>Region</div><div ui-region="named">Region</div>'
			app = new Marionette.Application
			app.start()

		it 'must identify regions based on ui-region attribute', ->
			expect(app.dynamicRegion).toEqual jasmine.any Marionette.Region
			expect(app.namedRegion).toEqual jasmine.any Marionette.Region

	describe 'when dynamic region is not setup', ->

		beforeEach ->
			setFixtures '<div ui-region="named">Region</div>'
			app = new Marionette.Application

		it 'app.start() must throw error', ->
			expect( -> app.start() ).toThrow()
