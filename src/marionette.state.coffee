
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


_.extend Marionette.LayoutView::,
	
	render: ->
		@_ensureViewIsIntact()

		if @_firstRender
		  	# if this is the first render, don't do anything to
		  	# reset the regions
		  	@_firstRender = false
		else
		  	# If this is not the first render call, then we need to
		  	# re-initialize the `el` for each region
		  	@_reInitializeRegions()
		
		Marionette.ItemView.prototype.render.apply @, arguments
		@_identifyRegions()
		@

	_identifyRegions : ->
		@$el.find('[ui-region]').each (index, region)=>
			regionName = $(region).attr 'ui-region'
			if _.isEmpty regionName
				regionName = 'dynamicRegion'
			else
				regionName = "#{regionName}Region"
			@addRegion regionName, selector : $(region)

		