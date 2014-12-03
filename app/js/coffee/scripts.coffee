# coffescript code here
Marionette.RegionControllers::controllers = window

class RootCtrl extends Marionette.RegionController
	initialize : ->
		@show new Marionette.LayoutView template : '#root-template'


class LoginCtrl extends Marionette.RegionController
	initialize : ->
		@show new Marionette.ItemView template : '<div><a href="#/root/universities">Go</a></div>'

class HeaderCtrl extends Marionette.RegionController
	initialize : ->
		@show new Marionette.ItemView template : '<div>Awesome HeaderCtrl</div>'

class LeftNavCtrl extends Marionette.RegionController
	initialize : ->
		@show new Marionette.ItemView template : '<div>Awesome LeftNav ctrl</div>'

class UniversitieslistCtrl extends Marionette.RegionController
	initialize : ->
		@show new Marionette.ItemView template : '<div>Awesome UniversitieslistCtrl
												<a href="#/root/universities/23">Go</a></div>'

class UniversitiesSingleCtrl extends Marionette.RegionController
	initialize : ->
		@show new Marionette.ItemView template : '<div>Awesome UniversitiesSingleCtrl <a href="#/root/universities">Go</a></div>'


jQuery(document).ready ($)->


	class AppStates extends Marionette.AppStates

		appStates :
			'login' : url : '/login'
			'root' :
				url : '/root'
				sections :
					'header' :
						ctrl : 'HeaderCtrl'
					'leftnav' :
						ctrl : 'LeftNavCtrl'
			'universitieslist' :
				parent : 'root'
				url : '/universities'
			'universitiesSingle' :
				parent : 'root'
				url : '/universities/:id'

	App.addInitializer ->
		a = new AppStates app : App
		Backbone.history.start()

	App.start()

