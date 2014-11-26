class Marionette.RegionControllers

	regionControllersLookup : ->
		if not window.RegionControllers
			window.RegionControllers = {}

		window.RegionControllers

	getRegionController : (name)->
		lookUp = Marionette.RegionControllers::regionControllersLookup()
		if not _.isUndefined lookUp[name]
			return lookUp[name]
		else
			throw new Marionette.Error
							message : 'region controller not found'