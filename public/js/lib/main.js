(function() {
  var AppView, DoneView, FormView, MainView, ToDoForm, app, loading, router, _ref, _ref1, _ref2, _ref3, _ref4,
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

}).call(this);
