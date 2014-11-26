_.extend Marionette.Application::,
	
	start : (options = {})->
		_possibleRegions = 
		$('[ui-region]').each (index, region)=>
			regionName = $(region).attr 'ui-region'
			if _.isEmpty regionName
				regionName = 'dynamicRegion'
			else
				regionName = "#{regionName}Region"
			@_regionManager.addRegion regionName, selector : $(region)

		@triggerMethod 'before:start', options
		@_initCallbacks.run options, @
		@triggerMethod 'start', options