describe 'Marionette.LayoutView', ->

	layoutView = null
	beforeEach ->
		class LV extends Marionette.LayoutView
			template : '<div>
							<div ui-region>Region</div>
							<div ui-region="named">Region named</div>
						</div>'

		layoutView = new LV
		layoutView.render()

	describe 'on render of layout view', ->
		it 'must identify regions based on ui-region', ->
			expect(layoutView.dynamicRegion).toEqual jasmine.any Marionette.Region
			expect(layoutView.namedRegion).toEqual jasmine.any Marionette.Region

