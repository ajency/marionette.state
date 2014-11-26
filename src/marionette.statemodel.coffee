class Marionette.State extends Backbone.Model

	idAttribute : 'name'

	defaults : ->
		ctrl : ''
		parent : false
		status : 'inactive'

	isActive : ->
		@get('status') is 'active'

	isChildState : ->
		@get('parent') isnt false