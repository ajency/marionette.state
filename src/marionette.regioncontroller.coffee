###
# Region Controller
# -----------------

# Responsible for controlling the region. 
# Showing/Removing view inside a region
#
# Region Controller requires a region instance as argument.
# parentCtrl and stateParams are optional arguments 
# Region controller will usually represent a state in an 
# application.
#
###

class Marionette.RegionController extends Marionette.Controller

	###
	# Constructor function of the controller
	# sets the region, parent controller, state parameters
	# and call the parent constructor
	###
	constructor : (options = {})->
		
		if not options.region
			throw new Marionette.Error('region param missing')

		@_region = options.region

		@_parent = options.parent ? false

		@_stateParams = options.stateParams ? []

		super options

	###
	# Return the region of the controlller
	###
	getRegion : ->

		if not @_region
			return false

		return @_region

	###
	# Return the parent controller
	# returns false if not called with parent controller
	###
	parent : ->

		if not @_parent
			return false

		return @_parent

	###
	# Returns the parameters passed to the controller
	###
	getParams : ->

		if not @_stateParams
			return @_stateParams

		return @_stateParams


	###
	# renders the view inside the region
	###
	show : (view)->
		view.once 'show', => 
			@_currentView = view
			@triggerMethod 'view:show', view
		
		if @getRegion() isnt false
			@getRegion().show view

	###
	# Returns the current view rendered inside the region
	###
	getCurrentView : ->
		
		if not @_currentView
			return false 

		return @_currentView

	###
	# Overridden destroy method
	# removes the reference to external object
	# for memory cleanup
	###
	destroy : (args...)->
		delete @_region
		delete @_stateParams
		delete @_parent
		delete @_currentView
		super args...





