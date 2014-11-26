
_ = require 'underscore'

module.exports = (grunt) ->

	require("load-grunt-tasks") grunt

	grunt.initConfig

		preprocess :
			build:
				src: "src/build/marionette.state.coffee"
				dest: "tmp/marionette.state.coffee"
			specs :
				src : [ "spec/specs/marionette.state.spec.coffee" ]
				dest : "tmp/marionette.state.spec.coffee"


		# produce index.html by target
		coffee :
			options :
				bare : true
			compile :
				files :
					"tmp/marionette.state.js" : "tmp/marionette.state.coffee"
					"tmp/marionette.state.spec.js" : "tmp/marionette.state.spec.coffee"
			distribution :
				files :
					"dist/marionette.state.js" : "tmp/marionette.state.coffee"

		jasmine:
			test:
				options:
					specs: 'tmp/marionette.state.spec.js'
				src: [
					'bower_components/underscore/underscore.js'
					'bower_components/jquery/dist/jquery.js'
					'bower_components/backbone/backbone.js'
					'bower_components/backbone.marionette/lib/backbone.marionette.js'
					'bower_components/jasmine-jquery/lib/jasmine-jquery.js'
					'bower_components/jasmine-ajax/lib/mock-ajax.js'
					'tmp/marionette.state.js'
				]

		watch:
			options:
				spawn: false
				interrupt: true
			source:
				files: [
					"src/**/*.coffee"
					"spec/**/*.coffee"
				]
				tasks: ["preprocess:build","preprocess:specs","coffee:compile", "jasmine:test"]


	grunt.registerTask "dev","Start development", [
		"preprocess"
		"coffee:compile"
		"jasmine:test"
		"watch"
	]

	grunt.registerTask "dist", "Create distribution build", [
		"preprocess"
		"coffee:compile"
		"jasmine:test"
		"coffee:distribution"
	]

