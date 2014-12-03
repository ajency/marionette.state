# coffescript code here
Marionette.RegionControllers::controllers = window

class RootCtrl extends Marionette.RegionController
	initialize : ->
		@show new Marionette.LayoutView template : '#root-template'


class LoginCtrl extends Marionette.RegionController
	initialize : ->
		@show new Marionette.ItemView template : '#login-template'

class HeaderCtrl extends Marionette.RegionController
	initialize : ->
		@show new Marionette.ItemView template : '<div><nav role="navigation" class="navbar navbar-default navbar-static-top">
      <!-- We use the fluid option here to avoid overriding the fixed width of a normal container within the narrow content columns. -->
      <div class="container-fluid">
        <div class="navbar-header">
          <button data-target="#bs-example-navbar-collapse-8" data-toggle="collapse" class="navbar-toggle collapsed" type="button">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a href="#" class="navbar-brand">Brand</a>
        </div>

        <!-- Collect the nav links, forms, and other content for toggling -->
        <div id="bs-example-navbar-collapse-8" class="collapse navbar-collapse">
          <ul class="nav navbar-nav">
            <li class="active"><a href="#">Home</a></li>
            <li><a href="#">Link</a></li>
            <li><a href="#">Link</a></li>
          </ul>
        </div><!-- /.navbar-collapse -->
      </div>
    </nav></div>'

class LeftNavCtrl extends Marionette.RegionController
	initialize : ->
		@show new Marionette.ItemView template : '<div><ul style="max-width: 300px;" class="nav nav-pills nav-stacked">
      <li class="active" role="presentation"><a href="#/universities/23">universities</a></li>
      <li role="presentation"><a href="#/socities">socities</a></li>
      <li role="presentation"><a href="#/socities/23">socities one</a></li>
    </ul></div>'

class UniversitieslistCtrl extends Marionette.RegionController
	initialize : ->
		@show new Marionette.ItemView template : '<div>Awesome UniversitieslistCtrl
												<a href="#/universities/23">Go</a>
												<a href="#/socities">socities</a></div>'

class SocitiesListCtrl extends Marionette.RegionController
	initialize : ->
		@abc = '123'
		@show new Marionette.ItemView template : '<div>Awesome SocitiesListCtrl
												<a href="#/universities/23">Go</a></div>'

class SocialSingle extends Marionette.LayoutView
	template : '#socity-single-template'
	onShow : ->
		@$el.find('.nav-pills li a').first().trigger 'click'
		#@$el.find('.nav-pills li').first().click()

class SocitiesSingleCtrl extends Marionette.RegionController
	initialize : ->
		view = new SocialSingle()
		@show view

class SocitiesTab1Ctrl extends Marionette.RegionController
	initialize : ->
		@show new Marionette.ItemView template : '<div>Awesome SocitiesTab1Ctrl</div>'

class SocitiesTab2Ctrl extends Marionette.RegionController
	initialize : ->
		@show new Marionette.ItemView template : '<div>Awesome SocitiesTab2Ctrl</div>'

class SocitiesTab3Ctrl extends Marionette.RegionController
	initialize : ->
		@show new Marionette.ItemView template : '<div>Awesome SocitiesTab3Ctrl</div>'

class UniversitiesSingleCtrl extends Marionette.RegionController
	initialize : ->
		@show new Marionette.ItemView template : '<div>Awesome UniversitiesSingleCtrl <a href="#/universities">Go</a></div>'


jQuery(document).ready ($)->


	class AppStates extends Marionette.AppStates

		appStates :
			'login' : url : '/login'
			'root' :
				url : '/'
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
			'socitiesList' :
				parent : 'root'
				url : '/socities'
			'socitiesSingle' :
				parent : 'root'
				url : '/socities/:id'
			'socitiesTab1' :
				parent : 'socitiesSingle'
				url : '/tab1'
			'socitiesTab2' :
				parent : 'socitiesSingle'
				url : '/tab2'
			'socitiesTab3' :
				parent : 'socitiesSingle'
				url : '/tab3'


	App.addInitializer ->
		new AppStates app : App
		Backbone.history.start()
		App.navigate '/socities/23/tab3', true

	App.start()

