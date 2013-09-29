
class Todo extends Backbone.Model
	urlRoot: "/api/todos/"
	defaults:
		id: null
		name: null
		is_done: null
		deadline: null
		comment: null
		updated_at: null
		created_at: null


class TodoList extends Backbone.Collection
	model: Todo
	url: "/api/todos/"
	parse: (response) ->
		console.log response
		console.error response.error if response.error
		response.todos # TODO: サーバー側に合わせる

