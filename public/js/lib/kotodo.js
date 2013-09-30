(function() {
  var App, AppView, MainView, Router, Todo, TodoForm, TodoList, TodoView, app, router, _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App = (function(_super) {
    __extends(App, _super);

    function App() {
      _ref = App.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    App.prototype.initialize = function() {};

    /* とりあえずロード進捗表示は後で実装
    	# セオリーに反するけれどとりあえずここにおいておく
    	loading = new class
    		constructor: ->
    		# ローディングダイアログを表示
    		show: ->
    		# ローディングダイアログを隠す
    		# timeout: タイムアウト時間[ms]
    		hide: (timeout=1000) ->
    			
    	defaults:
    		loadingCount: 0 # ローディング中のモデル数
    		
    	beginLoading: ->
    		c = @get "loadingCount"
    		loading.show() if c is 0
    		@set "loadingCount", c + 1
    		
    	endLoading: (timeout) ->
    		c = @get "loadingCount"
    		loading.hide() if c is 1
    		@set "loadingCount", c - 1
    */


    return App;

  })(Backbone.Model);

  Todo = (function(_super) {
    __extends(Todo, _super);

    function Todo() {
      _ref1 = Todo.__super__.constructor.apply(this, arguments);
      return _ref1;
    }

    Todo.prototype.urlRoot = "/api/todos/";

    Todo.prototype.defaults = {
      id: null,
      name: null,
      is_done: null,
      deadline: null,
      comment: null,
      updated_at: null,
      created_at: null
    };

    return Todo;

  })(Backbone.Model);

  TodoList = (function(_super) {
    __extends(TodoList, _super);

    function TodoList() {
      _ref2 = TodoList.__super__.constructor.apply(this, arguments);
      return _ref2;
    }

    TodoList.prototype.model = Todo;

    TodoList.prototype.url = "/api/todos/";

    TodoList.prototype.parse = function(response) {
      console.log(response);
      if (response.error) {
        console.error(response.error);
      }
      return response.todos;
    };

    return TodoList;

  })(Backbone.Collection);

  AppView = (function(_super) {
    __extends(AppView, _super);

    function AppView() {
      _ref3 = AppView.__super__.constructor.apply(this, arguments);
      return _ref3;
    }

    AppView.prototype.el = $("body");

    AppView.prototype.initialize = function() {};

    AppView.prototype.events = {
      "click #create-new-task": "renderTodoForm"
    };

    AppView.prototype.renderTodoForm = function() {
      return $("#todo-form").fadeIn(500).html(new TodoForm().render().el);
    };

    AppView.prototype.render = function() {
      return this;
    };

    return AppView;

  })(Backbone.View);

  MainView = (function(_super) {
    __extends(MainView, _super);

    function MainView() {
      _ref4 = MainView.__super__.constructor.apply(this, arguments);
      return _ref4;
    }

    MainView.prototype.initialize = function(opts) {
      this.template = _.template("<ul class=\"panel-group\" id=\"todo-accordion\"></ul>");
      this.$el.html(this.template());
      this.elTodoList = this.$el.find("ul");
      this.todos = new TodoList();
      this.todos.fetch();
      this.listenTo(this.todos, "add", this.addOneTodo);
      return this.listenTo(this.todos, "reset", this.resetTodoList);
    };

    MainView.prototype.addOneTodo = function(todo) {
      var view;
      view = new TodoView({
        model: todo
      });
      return this.elTodoList.append(view.render().el);
    };

    MainView.prototype.resetTodoList = function() {
      this.elTodoList.empty();
      return this.todos.each(this.addOneTodo, this);
    };

    MainView.prototype.render = function() {
      this.resetTodoList();
      return this;
    };

    return MainView;

  })(Backbone.View);

  TodoView = (function(_super) {
    __extends(TodoView, _super);

    function TodoView() {
      _ref5 = TodoView.__super__.constructor.apply(this, arguments);
      return _ref5;
    }

    TodoView.prototype.tagName = "li";

    TodoView.prototype.className = "panel panel-default";

    TodoView.prototype.initialize = function() {
      this.todoTemplate = _.template("<div class=\"panel-heading <%\n		if (deadline && new Date(deadline) < new Date()) { %>overdue<% } %>\">\n	<div class=\"checkbox-inline\">\n		<input type=\"checkbox\"<%= is_done ? \" checked='checked'\" : \"\" %> /> \n		<a class=\"accordion-toggle\" data-parent=\"#todo-accordion\" data-toggle=\"collapse\" href=\"#todo_collapse_<%= id %>\">\n			<%= name %>\n		</a>\n	</div>\n	<span class=\"pull-right\">\n		<% if (deadline) { %>\n			(Deadline: <%= new Date(deadline).toLocaleDateString() %>)\n		<% } else { %>\n			(no deadline)\n		<% } %>\n		<a class=\"btn btn-xs btn-default edit\" href=\"javascript: void 0;\">edit</a>\n		<a class=\"btn btn-xs btn-default delete\" href=\"javascript: void 0;\">delete</a>\n	</span>\n</div>\n<div id=\"todo_collapse_<%= id %>\" class=\"panel-collapse collapse\">\n	<div class=\"panel-body\">\n		<% if (comment) { %>\n			<%= comment %>\n		<% } else { %>\n			no comment\n		<% } %>\n	</div>\n</div>");
      this.formTemplate = _.template("<form>\n	<div class=\"panel-heading\">\n		<div class=\"checkbox-inline\">\n			<input type=\"text\" name=\"name\" class=\"form-control\" value=\"<%= name %>\" />\n		</div>\n		<span class=\"pull-right\">\n			<input type=\"datetime\" class=\"form-control\" name=\"deadline\" value=\"<%= deadline %>\" placeholder=\"deadline\" />\n		</span>\n	</div>\n	<div class=\"panel-body\">\n		<div class=\"panel-body\">\n			<div class=\"form-group\">\n				<label>Comment:</label>\n				<textarea name=\"comment\" class=\"form-control\"><%= comment %></textarea>\n			</div>\n			<button type=\"submit\" class=\"btn btn-primary\">Update</button>\n			<button type=\"button\" class=\"btn btn-default cancel\">Cancel</button>\n		</div>\n	</div>\n</form>");
      return this.template = this.todoTemplate;
    };

    TodoView.prototype.events = {
      "click a.edit": "editTodo",
      "click a.delete": "deleteTodo",
      "click input[type=checkbox]": "toggleDone",
      "submit form": "updateTodo",
      "click .cancel": "cancelSubmit"
    };

    TodoView.prototype.toggleDone = function() {
      console.log("TODO: ");
      return this.$el.slideUp(500);
    };

    TodoView.prototype.editTodo = function(e) {
      this.template = this.formTemplate;
      return this.render();
    };

    TodoView.prototype.deleteTodo = function(e) {
      var _this = this;
      if (!confirm("Are you sure you want to delete this task?")) {
        return false;
      }
      console.log(arguments, this.model);
      this.model.destroy({
        success: function(model, response) {
          _this.$el.slideUp(500);
          return console.log("delete successfully.");
        }
      });
      return false;
    };

    TodoView.prototype.cancelSubmit = function() {
      this.template = this.todoTemplate;
      return this.render();
    };

    TodoView.prototype.updateTodo = function(e) {
      var _this = this;
      this.model.save({
        name: this.$el.find("input[name=name]").val(),
        deadline: this.$el.find("input[name=deadline]").val(),
        comment: this.$el.find("textarea[name=comment]").val()
      }, {
        success: function(model, response) {
          return _this.cancelSubmit();
        },
        error: function(model, response) {
          return console.error(response);
        }
      });
      return false;
    };

    TodoView.prototype.render = function() {
      this.$el.html(this.template(this.model.toJSON()));
      return this;
    };

    return TodoView;

  })(Backbone.View);

  TodoForm = (function(_super) {
    __extends(TodoForm, _super);

    function TodoForm() {
      _ref6 = TodoForm.__super__.constructor.apply(this, arguments);
      return _ref6;
    }

    TodoForm.prototype.initialize = function() {
      this.template = _.template("<form method=\"post\" action=\"/api/todos/\" role=\"form\">\n	<div class=\"form-todo\">\n		<input type=\"text\" class=\"form-control\" name=\"name\" placeholder=\"New ToDo\" value=\"<%= name %>\" />\n	</div>\n	<div class=\"panel-group\">\n		<div class=\"panel panel-default\">\n			<a class=\"accordion-toggle\" data-toggle=\"collapse\" href=\"#collapse-form\">\n				<div class=\"panel-heading\">\n					<h4 class=\"panel-title\"><span class=\"glyphicon glyphicon-arrow-down\"></span> Detail</h4>\n				</div>\n			</a>\n		</div>\n	</div>\n	<div id=\"collapse-form\" class=\"panel-collapse collapse\">\n		<div class=\"panel-body\">\n			<div class=\"form-group\">\n				<lable for=\"comment\">Comment</label>\n				<textarea class=\"form-control\" name=\"comment\" placeholder=\"Comment\" />\n			</div>\n			<div class=\"form-group\">\n				<label for=\"form-deadline\">Deadline</label>\n				<input type=\"datetime\" name=\"deadline\" class=\"form-control\" id=\"form-deadline\" />\n			</div>\n		</div>\n	</div>\n	<div style=\"overflow: hidden;\">\n		<button type=\"submit\" class=\"btn btn-default btn-primary pull-right\">Submit</button>\n	</div>\n</form>");
      return this.model != null ? this.model : this.model = new Todo();
    };

    TodoForm.prototype.events = {
      "submit form": "submitNewTodo"
    };

    TodoForm.prototype.submitNewTodo = function(data) {
      var _this = this;
      data = {};
      this.$el.find("input[type=text]").each(function() {
        var t;
        t = $(this);
        return data[t.attr("name")] = t.val();
      });
      new Todo().save({
        name: this.$el.find("input[name=name]").val(),
        comment: this.$el.find("textarea[name=comment]").val(),
        deadline: this.$el.find("input[name=deadline]").val()
      }, {
        success: function(model, response, options) {
          _this.$el.hide();
          return Backbone.history.loadUrl();
        },
        error: function(model, response, options) {
          return console.log(arguments);
        }
      });
      return false;
    };

    TodoForm.prototype.render = function() {
      this.$el.html(this.template(this.model.toJSON()));
      return this;
    };

    return TodoForm;

  })(Backbone.View);

  Router = (function(_super) {
    __extends(Router, _super);

    function Router() {
      _ref7 = Router.__super__.constructor.apply(this, arguments);
      return _ref7;
    }

    Router.prototype.routes = {
      "": "main",
      "done": "done"
    };

    Router.prototype.main = function() {
      return $("#content").html((new MainView).render().el);
    };

    Router.prototype.done = function() {
      return $("#content").html((new MainView({
        is_done: true
      })).render().el);
    };

    return Router;

  })(Backbone.Router);

  app = new App;

  router = new Router;

  Backbone.emulateJSON = true;

  (new AppView({
    model: app
  })).render();

  Backbone.history.start({
    pushState: true,
    root: "/app/"
  });

}).call(this);
