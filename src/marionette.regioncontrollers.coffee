class Marionette.RegionControllers

	controllers : {}

	getRegionController : (name)->
		if not _.isUndefined @controllers[name]
			return @controllers[name]
		else
			throw new Marionette.Error
						message : "#{name} controller not found"