_.extend Marionette.Application::,

	start : (options = {})->
		@_detectRegions()
		@triggerMethod 'before:start', options
		@_initCallbacks.run options, @
		@triggerMethod 'start', options

	_detectRegions : ->
		_possibleRegions =
		$('[ui-region]').each (index, region)=>
			regionName = $(region).attr 'ui-region'
			if _.isEmpty regionName
				regionName = 'dynamicRegion'
			else
				regionName = "#{regionName}Region"

			@_regionManager.addRegion regionName, selector : $(region)

		if _.isUndefined @dynamicRegion
			throw new Marionette.Error
							message : 'Need atleast one dynamic region( [ui-region] )'
