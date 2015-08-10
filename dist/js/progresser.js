(function($) {
  var Progresser, instance;
  Progresser = (function() {
    function Progresser(name) {
      this.name = name;
      this._totalWeight = 0;
      this._currentWeight = 0;
      this._debug = false;
      this.deferred = new $.Deferred();
    }

    Progresser.prototype.setup = function(options) {
      this._totalWeight = options.totalWeight;
      if (typeof console !== "undefined" && console !== null) {
        this._debug = options.debug;
      }
      if (this._debug) {
        this._logTime(false);
        this._logWeight();
      }
    };

    Progresser.prototype.advance = function(weight) {
      this._currentWeight += weight;
      if (this._debug) {
        this._logTime(true);
        this._logWeight();
      }
      this.deferred.notify(this._currentWeight, this._totalWeight);
    };

    Progresser.prototype.collect = function() {
      var advance, complete, imageLoaded, imagesComplete;
      advance = this.advance;
      complete = this._complete;
      imagesComplete = (function(_this) {
        return function(instance) {
          _this._complete();
        };
      })(this);
      imageLoaded = (function(_this) {
        return function(instance, image) {
          var weight;
          weight = $(image.img).data('weight');
          _this.advance(weight);
        };
      })(this);
      $('.progresser-wait').voila({
        method: 'onload'
      }).always(imagesComplete).progress(imageLoaded);
    };

    Progresser.prototype._complete = function() {
      this.deferred.resolve();
      if (this._debug) {
        this._logComplete();
      }
    };

    Progresser.prototype._logWeight = function() {
      console.log('progresser weight:', this._currentWeight, 'of', this._totalWeight);
    };

    Progresser.prototype._logTime = function(timeEnd) {
      if (timeEnd) {
        console.timeEnd('progresser');
      }
      console.time('progresser');
    };

    Progresser.prototype._logComplete = function() {
      console.log('progresser completed');
    };

    return Progresser;

  })();
  instance = new Progresser();
  $.progresser = instance.deferred.promise(instance);
})(jQuery);
