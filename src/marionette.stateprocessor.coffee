
class Marionette.StateProcessor extends Marionette.Object

	initialize : (options = {})->
		@_state = stateModel = @getOption 'state'
		@_regionContainer = _regionContainer = @getOption 'regionContainer'

		if _.isUndefined(stateModel) or (stateModel instanceof Marionette.State isnt true)
			throw new Marionette.Error 'State model needed'

		if _.isUndefined(_regionContainer) or (_regionContainer instanceof Marionette.Application isnt true and _regionContainer instanceof Marionette.View isnt true)
			throw new Marionette.Error 'regionContainer needed. This can be Application object or layoutview object'

		@_stateParams = if options.stateParams then options.stateParams else []

		@_deferred = new Marionette.Deferred()

	process : ->
		_ctrlClassName = @_state.get 'ctrl'
		@_region = _region = @_regionContainer.dynamicRegion

		#get current cotrl
		currentCtrlClass = if _region._ctrlClass then _region._ctrlClass else false
		ctrlStateParams = if _region._ctrlStateParams then _region._ctrlStateParams else false
		arrayCompare = JSON.stringify(ctrlStateParams) is JSON.stringify(@_stateParams)
		if currentCtrlClass is _ctrlClassName and arrayCompare
			@_ctrlInstance = ctrlInstance = @_region._ctrlInstance
			@listenTo ctrlInstance, 'view:rendered', @_onViewRendered
			ctrlInstance.trigger "view:rendered", ctrlInstance._view
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
		@_deferred.resolve @_ctrlInstance



