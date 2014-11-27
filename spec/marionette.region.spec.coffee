describe 'Marionette.Region', ->

	beforeEach ->
		setFixtures sandbox()
		@region = new Marionette.Region el : '#sandbox'

	describe 'When seting the controller', ->

		beforeEach ->
			@region.setController 'CtrlClass'

		it 'must hold the ctrlclass property', ->
			expect(@region._ctrlClass).toEqual 'CtrlClass'


	describe 'When seting the controller states params', ->

		beforeEach ->
			@region.setControllerStateParams [12, 23]

		it 'must hold the _ctrlStateParams property', ->
			expect(@region._ctrlStateParams).toEqual [12, 23]







