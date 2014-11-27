
class Marionette.StateProcessor extends Marionette.Object

	initialize : (options = {})->

		@_state = stateModel = @getOption 'state'
		@_app = app = @getOption 'app'

		if _.isUndefined(stateModel) or (stateModel instanceof Marionette.State isnt true)
			throw new Marionette.Error 'State model needed'

		if _.isUndefined(app) or (app instanceof Marionette.Application isnt true)
			throw new Marionette.Error 'application instance needed'

		@_stateParams = if options.stateParams then options.stateParams else []

		@_deferred = new Marionette.Deferred()

	process : ->
		_ctrlClassName = @_state.get 'ctrl'
		@_ctrlClass = CtrlClass = Marionette.RegionControllers::getRegionController _ctrlClassName
		@_region = _region = @_app.dynamicRegion

		@_region.setController _ctrlClassName
		@_region.setControllerStateParams @_stateParams

		@_ctrlInstance = ctrlInstance = new CtrlClass
												region : _region
												stateParams : @_stateParams

		@listenTo ctrlInstance, 'view:rendered', @_onViewRendered

		@_deferred.promise()


	_onViewRendered : =>
		@_deferred.resolve true



