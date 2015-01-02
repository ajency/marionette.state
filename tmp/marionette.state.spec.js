afterEach(function() {
  window.location.hash = '';
  Backbone.history.stop();
  return Backbone.history.handlers.length = 0;
});

describe('Marionette.RegionController', function() {
  return it('must be defined', function() {
    return expect(Marionette.RegionController).toBeDefined();
  });
});
