
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
		@_region = _region = @_app.dynamicRegion

		#get current cotrl
		currentCtrlClass = _region._ctrlClass
		ctrlStateParams = _region._ctrlStateParams
		if currentCtrlClass is _ctrlClassName and ctrlStateParams is @_stateParams
			currentCtrlInstance = @_region._ctrlInstance
			currentCtrlInstance.trigger 'view:rendered'
			return @_deferred.promise()

		@_ctrlClass = CtrlClass = Marionette.RegionControllers::getRegionController _ctrlClassName

		@_ctrlInstance = ctrlInstance = new CtrlClass
											region : _region
											stateParams : @_stateParams

		@_region.setController _ctrlClassName
		@_region.setControllerStateParams @_stateParams
		@_region.setControllerInstance ctrlInstance
		@listenTo ctrlInstance, 'view:rendered', @_onViewRendered

		@_deferred.promise()

	getStatus : ->
		@_deferred.state()

	_onViewRendered : =>
		@_state.set 'status', 'resolved'
		@_deferred.resolve true



