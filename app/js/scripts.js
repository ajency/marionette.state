var HeaderCtrl, HeaderView, LeftNavCtrl, LoginCtrl, RootCtrl, SocialSingle, SocitiesListCtrl, SocitiesSingleCtrl, SocitiesTab1Ctrl, SocitiesTab2AbcCtrl, SocitiesTab3Ctrl, UniversitiesSingleCtrl, UniversitieslistCtrl,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

window.userData = {
  "ID": "1",
  "user_login": "admin",
  "user_nicename": "admin nicename",
  "user_email": "suraj@mailinator.com",
  "user_url": "",
  "user_registered": "2014-11-25 06:21:19",
  "user_activation_key": "",
  "user_status": "0",
  "display_name": "admin displayname",
  "caps": {
    "switch_themes": true,
    "edit_themes": true,
    "activate_plugins": true,
    "edit_plugins": true,
    "edit_users": true,
    "edit_files": true,
    "manage_options": true,
    "moderate_comments": true,
    "manage_categories": true,
    "manage_links": true,
    "upload_files": true,
    "import": true,
    "unfiltered_html": true,
    "edit_posts": true,
    "edit_others_posts": true,
    "edit_published_posts": true,
    "publish_posts": true,
    "edit_pages": true,
    "read": true,
    "level_10": true,
    "level_9": true,
    "level_8": true,
    "level_7": true,
    "level_6": true,
    "level_5": true,
    "level_4": true,
    "level_3": true,
    "level_2": true,
    "level_1": true,
    "level_0": true,
    "edit_others_pages": true,
    "edit_published_pages": true,
    "publish_pages": true,
    "delete_pages": true,
    "delete_others_pages": true,
    "delete_published_pages": true,
    "delete_posts": true,
    "delete_others_posts": true,
    "delete_published_posts": true,
    "delete_private_posts": true,
    "edit_private_posts": true,
    "read_private_posts": true,
    "delete_private_pages": true,
    "edit_private_pages": true,
    "read_private_pages": true,
    "delete_users": true,
    "create_users": true,
    "unfiltered_upload": true,
    "edit_dashboard": true,
    "update_plugins": true,
    "delete_plugins": true,
    "install_plugins": true,
    "update_themes": true,
    "install_themes": true,
    "update_core": true,
    "list_users": true,
    "remove_users": true,
    "add_users": true,
    "promote_users": true,
    "edit_theme_options": true,
    "delete_themes": true,
    "export": true,
    "administrator": true
  }
};

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
      template: '#login-template'
    }));
  };

  return LoginCtrl;

})(Marionette.RegionController);

HeaderView = (function(_super) {
  __extends(HeaderView, _super);

  function HeaderView() {
    return HeaderView.__super__.constructor.apply(this, arguments);
  }

  HeaderView.prototype.template = '<div><nav role="navigation" class="navbar navbar-default navbar-static-top"> <!-- We use the fluid option here to avoid overriding the fixed width of a normal container within the narrow content columns. --> <div class="container-fluid"> <div class="navbar-header"> <button data-target="#bs-example-navbar-collapse-8" data-toggle="collapse" class="navbar-toggle collapsed" type="button"> <span class="sr-only">Toggle navigation</span> <span class="icon-bar"></span> <span class="icon-bar"></span> <span class="icon-bar"></span> </button> <a href="#" class="navbar-brand">Brand</a> </div> <div class="pull-right"> <div></div> </div> <!-- Collect the nav links, forms, and other content for toggling --> <div id="bs-example-navbar-collapse-8" class="collapse navbar-collapse"> <ul class="nav navbar-nav"> <li class="active"><a href="#">Home</a></li> <li><a href="#">Link</a></li> <li><a href="#">Link</a></li> </ul> </div><!-- /.navbar-collapse --> </div> </nav></div>';

  return HeaderView;

})(Marionette.ItemView);

HeaderCtrl = (function(_super) {
  __extends(HeaderCtrl, _super);

  function HeaderCtrl() {
    return HeaderCtrl.__super__.constructor.apply(this, arguments);
  }

  HeaderCtrl.prototype.initialize = function() {
    return this.show(new HeaderView({
      model: App.currentUser
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
      template: '<div><ul style="max-width: 300px;" class="nav nav-pills nav-stacked"> <li class="active" role="presentation"><a href="#/universities/23">universities</a></li> <li role="presentation"><a href="#/socities">socities</a></li> <li role="presentation"><a href="#/socities/23">socities one</a></li> </ul></div>'
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
    this.abc = '123';
    return this.show(new Marionette.ItemView({
      template: '<div>Awesome SocitiesListCtrl <a href="#/universities/23">Go</a></div>'
    }));
  };

  return SocitiesListCtrl;

})(Marionette.RegionController);

SocialSingle = (function(_super) {
  __extends(SocialSingle, _super);

  function SocialSingle() {
    return SocialSingle.__super__.constructor.apply(this, arguments);
  }

  SocialSingle.prototype.template = '#socity-single-template';

  SocialSingle.prototype.onShow = function() {
    return this.$el.find('.nav-pills li a').first().trigger('click');
  };

  return SocialSingle;

})(Marionette.LayoutView);

SocitiesSingleCtrl = (function(_super) {
  __extends(SocitiesSingleCtrl, _super);

  function SocitiesSingleCtrl() {
    return SocitiesSingleCtrl.__super__.constructor.apply(this, arguments);
  }

  SocitiesSingleCtrl.prototype.initialize = function() {
    var view;
    view = new SocialSingle();
    return this.show(view);
  };

  return SocitiesSingleCtrl;

})(Marionette.RegionController);

SocitiesTab1Ctrl = (function(_super) {
  __extends(SocitiesTab1Ctrl, _super);

  function SocitiesTab1Ctrl() {
    return SocitiesTab1Ctrl.__super__.constructor.apply(this, arguments);
  }

  SocitiesTab1Ctrl.prototype.initialize = function() {
    return this.show(new Marionette.ItemView({
      template: '<div>Awesome SocitiesTab1Ctrl</div>'
    }));
  };

  return SocitiesTab1Ctrl;

})(Marionette.RegionController);

SocitiesTab2AbcCtrl = (function(_super) {
  __extends(SocitiesTab2AbcCtrl, _super);

  function SocitiesTab2AbcCtrl() {
    return SocitiesTab2AbcCtrl.__super__.constructor.apply(this, arguments);
  }

  SocitiesTab2AbcCtrl.prototype.initialize = function() {
    return this.show(new Marionette.ItemView({
      template: '<div>Awesome SocitiesTab2Ctrl</div>'
    }));
  };

  return SocitiesTab2AbcCtrl;

})(Marionette.RegionController);

SocitiesTab3Ctrl = (function(_super) {
  __extends(SocitiesTab3Ctrl, _super);

  function SocitiesTab3Ctrl() {
    return SocitiesTab3Ctrl.__super__.constructor.apply(this, arguments);
  }

  SocitiesTab3Ctrl.prototype.initialize = function() {
    return this.show(new Marionette.ItemView({
      template: '<div>Awesome SocitiesTab3Ctrl</div>'
    }));
  };

  return SocitiesTab3Ctrl;

})(Marionette.RegionController);

UniversitiesSingleCtrl = (function(_super) {
  __extends(UniversitiesSingleCtrl, _super);

  function UniversitiesSingleCtrl() {
    return UniversitiesSingleCtrl.__super__.constructor.apply(this, arguments);
  }

  UniversitiesSingleCtrl.prototype.initialize = function(options) {
    if (options == null) {
      options = {};
    }
    console.log(this.getParams());
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
      'login': true,
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
        url: '/universities/:id/aa/:one'
      },
      'socitiesList': {
        parent: 'root',
        url: '/socities'
      },
      'socitiesSingle': {
        parent: 'root',
        url: '/socities/:id'
      },
      'socitiesTab1': {
        parent: 'socitiesSingle',
        url: '/tab1'
      },
      'socitiesTab2': {
        parent: 'socitiesSingle',
        url: '/tab2',
        ctrl: SocitiesTab2AbcCtrl
      },
      'socitiesTab3': {
        parent: 'socitiesSingle',
        url: '/tab3'
      }
    };

    return AppStates;

  })(Marionette.AppStates);
  App.addInitializer(function() {
    new AppStates({
      app: App
    });
    return Backbone.history.start();
  });
  App.on('state:transition:start', function(evt, stateName, params) {
    if ('socitiesTab3' === stateName) {
      evt.preventDefault();
      return App.navigate('/socities/23/tab2', true);
    }
  });
  return App.start();
});
