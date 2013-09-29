(function() {
  var App, AppView, MainView, Router, Todo, TodoForm, TodoList, TodoView, app, router, _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App = (function(_super) {
    var loading;

    __extends(App, _super);

    function App() {
      _ref = App.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    loading = new ((function() {
      function _Class() {}

      _Class.prototype.show = function() {};

      _Class.prototype.hide = function(timeout) {
        if (timeout == null) {
          timeout = 1000;
        }
      };

      return _Class;

    })());

    App.prototype.defaults = {
      loadingCount: 0
    };

    App.prototype.beginLoading = function() {
      var c;
      c = this.get("loadingCount");
      if (c === 0) {
        loading.show();
      }
      return this.set("loadingCount", c + 1);
    };

    App.prototype.endLoading = function(timeout) {
      var c;
      c = this.get("loadingCount");
      if (c === 1) {
        loading.hide();
      }
      return this.set("loadingCount", c - 1);
    };

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

    AppView.prototype.initialize = function() {};

    AppView.prototype.render = function() {};

    return AppView;

  })(Backbone.View);

  MainView = (function(_super) {
    __extends(MainView, _super);

    function MainView() {
      _ref4 = MainView.__super__.constructor.apply(this, arguments);
      return _ref4;
    }

    MainView.prototype.initialize = function() {
      this.template = _.template("<ul></ul>");
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

    TodoView.prototype.initialize = function() {
      return this.template = _.template("ID: <%= id %><br />\nName: <%= name %><br />\nComment: <%= comment %><br />\nDeadline: <%= deadline %><br />\nDone: <%= is_done %><br />\nCreated At: <%= created_at %><br />\nUpdated At: <%= updated_at %><br />");
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

    return TodoForm;

  })(Backbone.View);

  Router = (function(_super) {
    __extends(Router, _super);

    function Router() {
      _ref7 = Router.__super__.constructor.apply(this, arguments);
      return _ref7;
    }

    Router.prototype.routes = {
      "": "main"
    };

    Router.prototype.main = function() {
      return $("#content").html((new MainView).render().el);
    };

    return Router;

  })(Backbone.Router);

  app = new App;

  router = new Router;

  (new AppView({
    model: app
  })).render();

  Backbone.history.start({
    pushState: true,
    root: "/app/"
  });

}).call(this);
