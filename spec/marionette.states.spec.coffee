describe 'Marionette.States', ->

	describe 'when the routes are configured and the controller exists', ->

		beforeEach ->
			@LoginCtrl = jasmine.createSpy 'LoginCtrl'
			StateRouter = Marionette.AppStates.extend
							appStates :
								'login' :
									url : 'login'

			@route = new StateRouter
			Backbone.history.start()
			@route.navigate('login', true)

		it 'must call the LoginCtrl controller ', ->
			expect(@LoginCtrl).toHaveBeenCalled()


	