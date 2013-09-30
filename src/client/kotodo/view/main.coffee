
# 最初に表示されるメインのToDoリスト画面

class MainView extends Backbone.View
	initialize: (opts) ->
		@template = _.template """
		<ul class="panel-group" id="todo-accordion"></ul>
		<ul class="pagination"></ul>
		"""
		@paginationTemplate = _.template """
			<li><a href="/app/page/<%= (page - 1) %>">&laquo;</a></li>
			<!--<li class="active"><a href="#">1 <span class="sr-only">(current)</span></a></li>-->
			<li><a href="/app/page/<%= (+page + 1) %>">&raquo;</a></li>
		</ul>
		"""
		@$el.html @template()
		# TODO: とりあえず
		@$el.find("ul.pagination").html @paginationTemplate({page: opts.page})
		# todo list
		@elTodoList = @$el.find "ul#todo-accordion"
		@todos = new TodoList()
		@todos.fetch
			data:
				is_done: if opts.is_done then 1 else 0
				p: opts.page
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


