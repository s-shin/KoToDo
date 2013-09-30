
# AppViewはページ全体に渡る制御を行う。

class AppView extends Backbone.View
	el: $("body")
		
	initialize: ->
		
	events:
		"click #create-new-task": "renderTodoForm"
		#"#show-done-tasks click":
	
	renderTodoForm: ->
		$("#todo-form").fadeIn(500).html new TodoForm().render().el
	
	render: ->
		@
	

