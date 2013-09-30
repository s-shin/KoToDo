
class TodoForm extends Backbone.View
	initialize: ->
		@template = _.template """
		<form method="post" action="/api/todos/" role="form">
			<div class="form-todo">
				<input type="text" class="form-control" name="name" placeholder="New ToDo" value="<%= name %>" />
			</div>
			<div class="panel-group">
				<div class="panel panel-default">
					<a class="accordion-toggle" data-toggle="collapse" href="#collapse-form">
						<div class="panel-heading">
							<h4 class="panel-title"><span class="glyphicon glyphicon-arrow-down"></span> Detail</h4>
						</div>
					</a>
				</div>
			</div>
			<div id="collapse-form" class="panel-collapse collapse">
				<div class="panel-body">
					<div class="form-group">
						<lable for="comment">Comment</label>
						<textarea class="form-control" name="comment" placeholder="Comment" />
					</div>
					<div class="form-group">
						<label for="form-deadline">Deadline</label>
						<input type="datetime" name="deadline" class="form-control" id="form-deadline" />
					</div>
				</div>
			</div>
			<div style="overflow: hidden;">
				<button type="submit" class="btn btn-default btn-primary pull-right">Submit</button>
			</div>
		</form>
		"""
		@model ?= new Todo()
	
	events:
		"submit form": "submitNewTodo"
	
	submitNewTodo: (data) ->
		data = {}
		@$el.find("input[type=text]").each ->
			t = $(this)
			data[t.attr("name")] = t.val()
		new Todo().save {
			name: @$el.find("input[name=name]").val()
			comment: @$el.find("textarea[name=comment]").val()
			deadline: @$el.find("input[name=deadline]").val()
		}, {
			success: (model, response, options) =>
				@$el.hide()
				#router.navigate "/", {trigger: true}
				Backbone.history.loadUrl()
			error: (model, response, options) ->
				console.log arguments
		}
		false
	
	render: ->
		@$el.html @template(@model.toJSON())
		@

