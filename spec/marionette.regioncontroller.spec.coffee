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

	describe 'when showing the view inside the region', ->

		beforeEach ->
			setFixtures sandbox()
			@_region = new Marionette.Region el : '#sandbox'
			@regionCtrl = new Marionette.RegionController region : @_region

		describe 'when view is not instance of Backbone.View', ->

			it 'must throw an error', ->
				regionCtrl = @regionCtrl
				expect(-> regionCtrl.show('abc')).toThrow()

		describe 'when view instance passed', ->

			beforeEach ->
				spyOn(@_region, 'show')
				spyOn(@regionCtrl, 'trigger')
				@view  = new Marionette.ItemView()
				@regionCtrl.show @view
				@view.trigger 'show'

			it 'must have _view property equal to view', ->
				expect(@regionCtrl._view).toEqual @view

			it 'must run show function on the passed region', ->
				expect(@_region.show).toHaveBeenCalledWith @view

			describe 'when the view is rendered on screen', ->

				it 'ctrl must tigger "view:rendered" event', (done)->
					_.delay =>
						expect(@regionCtrl.trigger).toHaveBeenCalledWith 'view:rendered', @view
						done()
					, 101

	describe 'When the view inside is destroyed', ->

		beforeEach ->
			@view  = new Marionette.ItemView()
			setFixtures sandbox()
			@_region = new Marionette.Region el : '#sandbox'
			@regionCtrl = new Marionette.RegionController region : @_region
			@regionCtrl.show @view
			@view.destroy()










