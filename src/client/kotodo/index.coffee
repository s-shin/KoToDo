

class Router extends Backbone.Router
	
	routes:
		"": "main"
		"page/:page": "page"
		"done": "done"
		
	main: ->
		$("#content").html (new MainView({is_done: false, page: 1})).render().el
	
	page: (page) ->
		$("#content").html (new MainView({is_done: false, page: page})).render().el
	
	done: ->
		$("#content").html (new MainView({is_done: true})).render().el


app = new App
router = new Router
Backbone.emulateJSON = true
(new AppView({model: app})).render()
Backbone.history.start({pushState: true, root: "/app/"})
