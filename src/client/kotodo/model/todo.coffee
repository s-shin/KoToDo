
class ToDo extends Backbone.Model
	urlRoot: "/todos/"
	defaults:
		id: null
		name: null
		is_done: null
		deadline: null
		comment: null
		updated_at: null
		created_at: null


class ToDoList extends Backbone.Collection
	model: ToDo
	url: /todos/
	parse: (response) ->
		console.error response.error if response.error
		response.todo # TODO: サーバー側に合わせる

