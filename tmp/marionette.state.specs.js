var clearCurrentUser, setCurrentUser;

window.FB = {
  login: function() {},
  api: function(url, cb) {
    return cb({
      email: 'someemail@mail.com'
    });
  }
};

window.APIURL = 'http://localhost/project/wp-api';

setCurrentUser = function() {
  var userData;
  userData = {
    ID: 1,
    user_name: 'admin',
    user_email: 'admin@mailinator.com',
    caps: {
      edit_post: true,
      read_others_post: false
    }
  };
  return window.currentUser.set(userData);
};

clearCurrentUser = function() {
  return window.currentUser.clear();
};

beforeEach(function() {
  this.setFixtures = setFixtures;
  return this.loadFixtures = loadFixtures;
});

afterEach(function() {
  window.location.hash = '';
  Backbone.history.stop();
  return Backbone.history.handlers.length = 0;
});

describe('Marionette.State', function() {
  return describe('State initialization ', function() {
    return it('must be true', function() {
      return expect(true).toBe(true);
    });
  });
});
