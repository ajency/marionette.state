
class Marionette.RegionController extends Marionette.Controller

	constructor : (options = {})->

		if not options.region or ( options.region instanceof Marionette.Region isnt true )
			throw new Marionette.Error
				message: 'Region instance is not passed'

		@_parentCtrl = options.parentCtrl
		@_ctrlID = _.uniqueId 'ctrl-'
		@_region = options.region
		@_stateParams = options.stateParams ? []
		super options

	show : (view)->
		if view instanceof Backbone.View isnt true
			throw new Marionette.Error
				message: 'View instance is not valid Backbone.View'

		@_view = view
		@listenTo @_view, 'show', =>
					_.delay =>
						@trigger 'view:rendered', @_view
					, 10
		@_region.show view

	parent : ->
		@_parentCtrl

	getParams : ->
		@_stateParams


