
class TodoView extends Backbone.View
	tagName: "li"
	className: "panel panel-default"
	initialize: ->
		@template = _.template """
		<div class="panel-heading">
			<div class="checkbox-inline">
				<input type="checkbox"<%= is_done ? " checked='checked'" : "" %> /> 
				<a class="accordion-toggle" data-parent="#todo-accordion" data-toggle="collapse" href="#todo_collapse_<%= id %>">
					<%= name %>
				</a>
			</div>
			<span class="pull-right">
				created at <%= created_at %>
				<% if (deadline) { %>
					, deadline is <%= deadline %>
				<% } %>
				<a href="#">edit</a>
				<a href="#">delete</a>
			</span>
		</div>
		<div id="todo_collapse_<%= id %>" class="panel-collapse collapse">
			<div class="panel-body">
				<% if (comment) { %>
					<%= comment %>
				<% } else { %>
					no comment
				<% } %>
			</div>
		</div>
		<!--
		ID: <%= id %><br />
		Name: <%= name %><br />
		Comment: <%= comment %><br />
		Deadline: <%= deadline %><br />
		Done: <%= is_done %><br />
		Created At: <%= created_at %><br />
		Updated At: <%= updated_at %><br />
		-->
		"""
		
	render: ->
		@$el.html @template(@model.toJSON())
		@
		


	
	