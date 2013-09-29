
class TodoView extends Backbone.View
	tagName: "li"
	
	initialize: ->
		@template = _.template """
		ID: <%= id %><br />
		Name: <%= name %><br />
		Comment: <%= comment %><br />
		Deadline: <%= deadline %><br />
		Done: <%= is_done %><br />
		Created At: <%= created_at %><br />
		Updated At: <%= updated_at %><br />
		"""
		
	render: ->
		@$el.html @template(@model.toJSON())
		@
		


	
	