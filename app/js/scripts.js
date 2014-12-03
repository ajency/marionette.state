var HeaderCtrl, LeftNavCtrl, LoginCtrl, RootCtrl, SocitiesListCtrl, UniversitiesSingleCtrl, UniversitieslistCtrl,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Marionette.RegionControllers.prototype.controllers = window;

RootCtrl = (function(_super) {
  __extends(RootCtrl, _super);

  function RootCtrl() {
    return RootCtrl.__super__.constructor.apply(this, arguments);
  }

  RootCtrl.prototype.initialize = function() {
    return this.show(new Marionette.LayoutView({
      template: '#root-template'
    }));
  };

  return RootCtrl;

})(Marionette.RegionController);

LoginCtrl = (function(_super) {
  __extends(LoginCtrl, _super);

  function LoginCtrl() {
    return LoginCtrl.__super__.constructor.apply(this, arguments);
  }

  LoginCtrl.prototype.initialize = function() {
    return this.show(new Marionette.ItemView({
      template: '<div><a href="#/universities">Go</a></div>'
    }));
  };

  return LoginCtrl;

})(Marionette.RegionController);

HeaderCtrl = (function(_super) {
  __extends(HeaderCtrl, _super);

  function HeaderCtrl() {
    return HeaderCtrl.__super__.constructor.apply(this, arguments);
  }

  HeaderCtrl.prototype.initialize = function() {
    return this.show(new Marionette.ItemView({
      template: '<div>Awesome HeaderCtrl</div>'
    }));
  };

  return HeaderCtrl;

})(Marionette.RegionController);

LeftNavCtrl = (function(_super) {
  __extends(LeftNavCtrl, _super);

  function LeftNavCtrl() {
    return LeftNavCtrl.__super__.constructor.apply(this, arguments);
  }

  LeftNavCtrl.prototype.initialize = function() {
    return this.show(new Marionette.ItemView({
      template: '<div>Awesome LeftNav ctrl</div>'
    }));
  };

  return LeftNavCtrl;

})(Marionette.RegionController);

UniversitieslistCtrl = (function(_super) {
  __extends(UniversitieslistCtrl, _super);

  function UniversitieslistCtrl() {
    return UniversitieslistCtrl.__super__.constructor.apply(this, arguments);
  }

  UniversitieslistCtrl.prototype.initialize = function() {
    return this.show(new Marionette.ItemView({
      template: '<div>Awesome UniversitieslistCtrl <a href="#/universities/23">Go</a> <a href="#/socities">socities</a></div>'
    }));
  };

  return UniversitieslistCtrl;

})(Marionette.RegionController);

SocitiesListCtrl = (function(_super) {
  __extends(SocitiesListCtrl, _super);

  function SocitiesListCtrl() {
    return SocitiesListCtrl.__super__.constructor.apply(this, arguments);
  }

  SocitiesListCtrl.prototype.initialize = function() {
    return this.show(new Marionette.ItemView({
      template: '<div>Awesome SocitiesListCtrl <a href="#/universities/23">Go</a></div>'
    }));
  };

  return SocitiesListCtrl;

})(Marionette.RegionController);

UniversitiesSingleCtrl = (function(_super) {
  __extends(UniversitiesSingleCtrl, _super);

  function UniversitiesSingleCtrl() {
    return UniversitiesSingleCtrl.__super__.constructor.apply(this, arguments);
  }

  UniversitiesSingleCtrl.prototype.initialize = function() {
    return this.show(new Marionette.ItemView({
      template: '<div>Awesome UniversitiesSingleCtrl <a href="#/universities">Go</a></div>'
    }));
  };

  return UniversitiesSingleCtrl;

})(Marionette.RegionController);

jQuery(document).ready(function($) {
  var AppStates;
  AppStates = (function(_super) {
    __extends(AppStates, _super);

    function AppStates() {
      return AppStates.__super__.constructor.apply(this, arguments);
    }

    AppStates.prototype.appStates = {
      'login': {
        url: '/login'
      },
      'root': {
        url: '/',
        sections: {
          'header': {
            ctrl: 'HeaderCtrl'
          },
          'leftnav': {
            ctrl: 'LeftNavCtrl'
          }
        }
      },
      'universitieslist': {
        parent: 'root',
        url: '/universities'
      },
      'universitiesSingle': {
        parent: 'root',
        url: '/universities/:id'
      },
      'socitiesList': {
        parent: 'root',
        url: '/socities'
      }
    };

    return AppStates;

  })(Marionette.AppStates);
  App.addInitializer(function() {
    var a;
    a = new AppStates({
      app: App
    });
    return Backbone.history.start();
  });
  return App.start();
});
