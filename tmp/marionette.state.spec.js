afterEach(function() {
  window.location.hash = '';
  Backbone.history.stop();
  return Backbone.history.handlers.length = 0;
});

describe('Marionette.RegionController', function() {
  beforeEach(function() {
    setFixtures(sandbox());
    return this.region = new Marionette.Region({
      el: '#sandbox'
    });
  });
  it('must be defined', function() {
    return expect(Marionette.RegionController).toBeDefined();
  });
  describe('when initializing the controller', function() {
    beforeEach(function() {
      this.noRegionOptions = {};
      return this.withRegionOption = {
        region: this.region
      };
    });
    describe('when region instance is not passed', function() {
      return it('must throw an error', function() {
        return expect(function() {
          return new Marionette.RegionController(this.noRegionOptions);
        }).toThrow();
      });
    });
    return describe('when region instance is passed', function() {
      beforeEach(function() {
        return this.ctrl = new Marionette.RegionController(this.withRegionOption);
      });
      return it('getRegion() must return the region', function() {
        return expect(this.ctrl.getRegion()).toEqual(this.region);
      });
    });
  });
  describe('when initializing with parent controller', function() {
    beforeEach(function() {
      var _region;
      _region = new Marionette.Region({
        el: 'body'
      });
      this.parentCtrl = new Marionette.RegionController({
        region: _region
      });
      return this.ctrl = new Marionette.RegionController({
        region: this.region,
        parent: this.parentCtrl
      });
    });
    return it('parent() must return the parent controller', function() {
      return expect(this.ctrl.parent()).toEqual(this.parentCtrl);
    });
  });
  describe('when initializing with state parameters', function() {
    beforeEach(function() {
      this.stateParams = [1, 2];
      return this.ctrl = new Marionette.RegionController({
        region: this.region,
        stateParams: this.stateParams
      });
    });
    return it('getParams() must return state parameters', function() {
      return expect(this.ctrl.getParams()).toEqual(this.stateParams);
    });
  });
  describe('when showing the view inside region', function() {
    beforeEach(function() {
      this.view = new Marionette.ItemView({
        template: '<p>template</p>'
      });
      this.ctrl = new Marionette.RegionController({
        region: this.region
      });
      this.spy = spyOn(this.ctrl, 'triggerMethod');
      return this.ctrl.show(this.view);
    });
    it('getCurrentView() must return the view instance', function() {
      return expect(this.ctrl.getCurrentView()).toEqual(this.view);
    });
    return it('must trigger \'view:show\' event on view show ', function() {
      return expect(this.spy).toHaveBeenCalledWith('view:show', this.view);
    });
  });
  return describe('when destroying the controller', function() {
    beforeEach(function() {
      this.view = new Marionette.ItemView({
        template: '<p>template</p>'
      });
      this.ctrl = new Marionette.RegionController({
        region: this.region
      });
      this.ctrl.show(this.view);
      return this.ctrl.destroy();
    });
    return it('must not have _region, _stateParams, _currentView, _parent', function() {
      expect(this.ctrl._region).toBeUndefined();
      expect(this.ctrl._parent).toBeUndefined();
      expect(this.ctrl._stateParams).toBeUndefined();
      return expect(this.ctrl._currentView).toBeUndefined();
    });
  });
});
