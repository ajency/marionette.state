
_.extend Marionette.Region::,

	setController : (ctrlClass)->
		@_ctrlClass = ctrlClass

	setControllerStateParams : (params = [])->
		@_ctrlStateParams = params

	setControllerInstance :(ctrlInstance)->
		@_ctrlInstance = ctrlInstance

