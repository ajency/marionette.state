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
		return @_stateParams


	###
	# renders the view inside the region
	###
	show : (view)->
		view.once 'show', => @triggerMethod 'view:show', view
		@_currentView = view
		@getRegion().show view

	getCurrentView : ->
		@_currentView





