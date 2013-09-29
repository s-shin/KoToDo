
class MainView extends Backbone.View
	initialize: ->
		@template = _.template """
		<ul class="panel-group" id="todo-accordion"></ul>
		"""
		@$el.html @template()
		# todo list
		@elTodoList = @$el.find "ul"
		@todos = new TodoList()
		@todos.fetch()
		@listenTo @todos, "add", @addOneTodo
		@listenTo @todos, "reset", @resetTodoList
		
	addOneTodo: (todo) ->
		view = new TodoView {model: todo}
		@elTodoList.append view.render().el
		
	resetTodoList: ->
		@elTodoList.empty()
		@todos.each @addOneTodo, @
		
	render: ->
		@resetTodoList()
		@


