module.exports = (grunt) ->

	require("load-grunt-tasks") grunt

	grunt.initConfig

		preprocess :
			dev:
				src: "src/build/marionette-state.coffee"
				dest: "tmp/marionette-state.coffee"

		# produce index.html by target
		coffee :
			options :
				bare : true
			dev :
				files :
					"tmp/marionette-state.js" : "tmp/marionette-state.coffee"

		watch:
			options:
				livereload: true
				spawn: false
				interrupt: true

			dev:
				files: [
					"src/**/*.coffee"
				]
				tasks: ["preprocess:dev", "coffee:dev"]


	grunt.registerTask "dev", [
		"preprocess:dev"
		"coffee:dev"
		"watch:dev"
	]
