# mock FB API
window.FB =
	login : ->
	api : (url, cb)->
		cb email : 'someemail@mail.com'

# define API URL
window.APIURL = 'http://localhost/project/wp-api'

# set the current user
setCurrentUser = ->
	userData =
		ID : 1
		user_name : 'admin'
		user_email : 'admin@mailinator.com'
		caps :
			edit_post : true
			read_others_post : false

	window.currentUser.set userData

# reset the current user
clearCurrentUser = ->
	window.currentUser.clear()

beforeEach ->
	this.setFixtures   = setFixtures
	this.loadFixtures  = loadFixtures

afterEach ->
	window.location.hash = ''
	Backbone.history.stop()
	Backbone.history.handlers.length = 0


describe 'Marionette.Application on before start', ->

	app = null
	beforeEach ->
		setFixtures '<div ui-region>Region</div><div ui-region="named">Region</div>'
		app = new Marionette.Application
		app.start()

	it 'must identify regions based on ui-region ', ->
		expect(app.dynamicRegion).toEqual jasmine.any Marionette.Region
		expect(app.namedRegion).toEqual jasmine.any Marionette.Region


describe 'Marionette.LayoutView on render', ->

	layoutView = null
	beforeEach ->
		class LV extends Marionette.LayoutView
			template : '<div>
							<div ui-region>Region</div>
							<div ui-region="named">Region named</div>
						</div>'

		layoutView = new LV
		layoutView.render()
		
	it 'must identify regions based on ui-region', ->
		expect(layoutView.dynamicRegion).toEqual jasmine.any Marionette.Region
		expect(layoutView.namedRegion).toEqual jasmine.any Marionette.Region

