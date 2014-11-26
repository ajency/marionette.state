
class Marionette.State extends Backbone.Model

	idAttribute : 'name'

	defaults : ->
		ctrl : -> throw new Marionette.Error 'Controller not defined'
		parent : false
		status : 'inactive'

	initialize : (options = {})->
		if not options.name or _.isEmpty options.name
			throw new Marionette.Error 'State Name must be passed'

		stateName = options.name
		options.url = "/#{stateName}" if not options.url
		options.computed_url = options.url.substring 1
		options.url_to_array = [options.url]
		options.ctrl = @_ctrlName stateName if not options.ctrl

		@set options

	_ctrlName : (name)->
		name.replace /\w\S*/g, (txt)->
			return txt.charAt(0).toUpperCase() + txt.substr(1) + 'Ctrl'



	# isActive : ->
	# 	@get('status') is 'active'

	# getStatus : ->
	# 	@get 'status'

	# isChildState : ->
	# 	@get('parent') isnt false
