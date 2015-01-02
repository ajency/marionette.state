class Marionette.RegionControllers

	controllers : {}

	setLookup : (object)->
		if object isnt window and _.isUndefined window[object]
			throw new Marionette.Error 'Controller lookup object is not defined'

		@controllers = object

	getRegionController : (name)->
		if not _.isUndefined @controllers[name]
			return @controllers[name]
		else
			throw new Marionette.Error
						message : "#{name} controller not found"
