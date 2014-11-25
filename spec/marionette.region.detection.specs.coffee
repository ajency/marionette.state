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

