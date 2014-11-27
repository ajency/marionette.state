
class Marionette.StateProcessor extends Marionette.Object

	initialize : (options = {})->

		@_state = stateModel = @getOption 'state'
		if _.isUndefined(stateModel) or (stateModel instanceof Marionette.State isnt true)
			throw new Marionette.Error 'State model needed'

		@_deffered = new Marionette.Deferred()

	process : ->
		_ctrlClassName = @_state.get 'ctrl'
		@_ctrlClass = Marionette.RegionControllers::getRegionController _ctrlClassName

		@_region = ''
