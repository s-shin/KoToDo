
class TodoView extends Backbone.View
	tagName: "li"
	className: "panel panel-default"
	initialize: ->
		@todoTemplate = _.template """
		<div class="panel-heading">
			<div class="checkbox-inline">
				<input type="checkbox"<%= is_done ? " checked='checked'" : "" %> /> 
				<a class="accordion-toggle" data-parent="#todo-accordion" data-toggle="collapse" href="#todo_collapse_<%= id %>">
					<%= name %>
				</a>
			</div>
			<span class="pull-right">
				<% if (deadline) { %>
					(deadline: <%= deadline %>)
				<% } else { %>
					(no deadline)
				<% } %>
				<a class="btn btn-xs btn-default edit" href="javascript: void 0;">edit</a>
				<a class="btn btn-xs btn-default delete" href="javascript: void 0;">delete</a>
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
		"""
		@formTemplate = _.template """
		<form>
			<div class="panel-heading">
				<div class="checkbox-inline">
					<input type="text" name="name" class="form-control" value="<%= name %>" />
				</div>
				<span class="pull-right">
					<input type="datetime" class="form-control" name="deadline" value="<%= deadline %>" placeholder="deadline" />
				</span>
			</div>
			<div class="panel-body">
				<div class="panel-body">
					<div class="form-group">
						<label>Comment:</label>
						<textarea name="comment" class="form-control"><%= comment %></textarea>
					</div>
					<button type="submit" class="btn btn-primary">Update</button>
					<button type="button" class="btn btn-default cancel">Cancel</button>
				</div>
			</div>
		</form>
		"""
		@template = @todoTemplate
		
	events:
		"click a.edit": "editTodo"
		"click a.delete": "deleteTodo"
		"click input[type=checkbox]": "toggleDone"
		"submit form": "updateTodo"
		"click .cancel": "cancelSubmit"
	
	toggleDone: ->
		# TODO: サーバーの方にis_doneの変更を通知
		console.log "TODO: "
		@$el.slideUp(500)
	
	editTodo: (e) ->
		@template = @formTemplate
		@render()
	
	deleteTodo: (e) ->
		if not confirm("Are you sure you want to delete this task?")
			return false
		console.log arguments, @model
		@model.destroy
			success: (model, response) =>
				@$el.slideUp(500)
				console.log "delete successfully."
		false
	
	cancelSubmit: ->
		@template = @todoTemplate
		@render()
	
	updateTodo: (e) ->
		@model.save {
			name: @$el.find("input[name=name]").val()
			deadline: @$el.find("input[name=deadline]").val()
			comment: @$el.find("textarea[name=comment]").val()
		}, {
			success: (model, response) =>
				@cancelSubmit()
			error: (model, response) ->
				console.error response
		}
		false
		
	render: ->
		@$el.html @template(@model.toJSON())
		@
		


	
	