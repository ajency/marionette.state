
_.extend Marionette.Region::,

	setController : (ctrlClass)->
		@_ctrlClass = ctrlClass

	setControllerStateParams : (params = [])->
		@_ctrlStateParams = params
