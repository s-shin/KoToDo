(function() {
  var App, AppView, DoneView, FormView, MainView, ToDo, ToDoForm, ToDoList, ToDoView, app, loading, router, _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

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

  app = null;

  router = null;

  ToDoForm = (function(_super) {
    __extends(ToDoForm, _super);

    function ToDoForm() {
      _ref = ToDoForm.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    return ToDoForm;

  })(Backbone.Model);

  AppView = (function(_super) {
    __extends(AppView, _super);

    function AppView() {
      _ref1 = AppView.__super__.constructor.apply(this, arguments);
      return _ref1;
    }

    return AppView;

  })(Backbone.View);

  DoneView = (function(_super) {
    __extends(DoneView, _super);

    function DoneView() {
      _ref2 = DoneView.__super__.constructor.apply(this, arguments);
      return _ref2;
    }

    return DoneView;

  })(Backbone.View);

  MainView = (function(_super) {
    __extends(MainView, _super);

    function MainView() {
      _ref3 = MainView.__super__.constructor.apply(this, arguments);
      return _ref3;
    }

    return MainView;

  })(Backbone.View);

  FormView = (function(_super) {
    __extends(FormView, _super);

    function FormView() {
      _ref4 = FormView.__super__.constructor.apply(this, arguments);
      return _ref4;
    }

    return FormView;

  })(Backbone.View);

  App = (function(_super) {
    __extends(App, _super);

    function App() {
      _ref5 = App.__super__.constructor.apply(this, arguments);
      return _ref5;
    }

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

  ToDo = (function(_super) {
    __extends(ToDo, _super);

    function ToDo() {
      _ref6 = ToDo.__super__.constructor.apply(this, arguments);
      return _ref6;
    }

    ToDo.prototype.urlRoot = "/todos/";

    ToDo.prototype.defaults = {
      id: null,
      name: null,
      is_done: null,
      deadline: null,
      comment: null,
      updated_at: null,
      created_at: null
    };

    return ToDo;

  })(Backbone.Model);

  ToDoList = (function(_super) {
    __extends(ToDoList, _super);

    function ToDoList() {
      _ref7 = ToDoList.__super__.constructor.apply(this, arguments);
      return _ref7;
    }

    ToDoList.prototype.model = ToDo;

    ToDoList.prototype.url = /todos/;

    ToDoList.prototype.parse = function(response) {
      if (response.error) {
        console.error(response.error);
      }
      return response.todo;
    };

    return ToDoList;

  })(Backbone.Collection);

  ToDoView = (function(_super) {
    __extends(ToDoView, _super);

    function ToDoView() {
      _ref8 = ToDoView.__super__.constructor.apply(this, arguments);
      return _ref8;
    }

    ToDoView.prototype.initialize = function() {};

    ToDoView.prototype.render = function() {};

    ToDoView.prototype.events = function() {};

    return ToDoView;

  })(Backbone.View);

}).call(this);
