module.exports = (grunt) ->
	
	grunt.initConfig
		pkg: grunt.file.readJSON "package.json"
		
		copy:
			js:
				files: [{
					expand: true
					cwd: "bower_components/"
					flatten: true
					src: [
						"jquery/jquery.min.js"
						"bootstrap/dist/js/bootstrap.min.js"
						"underscore/underscore-min.js"
						#"underscore/underscore-min.map"
						"backbone/backbone-min.js"
						#"backbone/backbone-min.map"
					]
					dest: "public/js/vendor/"
				}]
			css:
				files: [{
					expand: true
					cwd: "bower_components/"
					flatten: true
					src: [
						"bootstrap/dist/css/bootstrap.min.css"
					]
					dest: "public/css/vendor/"
				}]
			font:
				files: [{
					expand: true
					cwd: "bower_components/bootstrap/dist/fonts"
					src: ["*"]
					dest: "public/font/"
				}]
		
		coffee:
			client:
				files: [{
					expand: true
					cwd: "src/client"
					src: ["*.coffee"]
					dest: "public/js/lib"
					ext: ".js"
				}]
		
		compass:
			dev:
				options:
					config: "compass_config.rb"
					environment: "development"
			dist:
				options:
					config: "compass_config.rb"
					environment: "production"
		
		concat:
			options:
				separator: ";\n"
			vendor_js:
				src: do ->
					DIR = "public/js/vendor/"
					files = [
						"underscore-min.js"
						"jquery.min.js"
						"bootstrap.min.js"
						"backbone-min.js"
					]
					files[i] = DIR + files[i] for i in [0...files.length]
					files
				dest: "public/js/vendor.js"
			vendor_css:
				src: ["public/css/vendor/**/*.css"]
				dest: "public/css/vendor.css"
			app_js:
				src: ["public/js/lib/**/*.js"]
				dest: "public/js/app.js"
			app_css:
				src: ["public/css/lib/**/*.css"]
				dest: "public/css/app.css"
		
		watch:
			client:
				files: ["src/client/**/*.coffee"]
				tasks: ["coffee:client", "concat:app_js"]
			sass:
				files: ["src/sass/**/*.scss"]
				tasks: ["compass:dev", "concat:app_css"]
	
	
	grunt.loadNpmTasks "grunt-contrib-copy"
	grunt.loadNpmTasks "grunt-contrib-compass"
	grunt.loadNpmTasks "grunt-contrib-coffee"
	grunt.loadNpmTasks "grunt-contrib-concat"
	grunt.loadNpmTasks "grunt-contrib-watch"
	
	grunt.registerTask "vendor", ["copy", "concat:vendor_js", "concat:vendor_css"]
	
	
