
# AppViewはページ全体に渡る制御を行う。

class AppView extends Backbone.View
	el: $("body")
		
	initialize: ->
		console.log @model
		console.log @
		
	events:
		"click #create-new-task": "renderTodoForm"
		#"#show-done-tasks click":
	
	renderTodoForm: ->
		$("#todo-form").show().html new TodoForm().render().el
	
	render: ->
		@
	

