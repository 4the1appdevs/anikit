// Generated by LiveScript 1.3.1
(function(){
  var easingFit, cubic, anikit, slide, ret;
  if (typeof require != 'undefined' && require !== null) {
    easingFit = require('easing-fit');
    cubic = require('cubic');
    anikit = require('../anikit');
  }
  slide = {
    prop: function(f, c){
      var value;
      value = this.value(f.value, c);
      return {
        transform: "matrix(" + anikit.util.m4to3(value.transform).join(',') + ")",
        opacity: c.fade ? value.opacity : 1
      };
    },
    value: function(t, c){
      return {
        transform: anikit.util[c.dir === 1 ? 'tx' : 'ty'](t * c.offset),
        opacity: c.fade && (t <= -0.8 || t >= 0.8) ? 0 : 1
      };
    }
  };
  ret = {
    name: 'slide',
    type: 'animation',
    preset: {
      "slide-ltr": import$({
        offset: 200
      }, slide),
      "slide-rtl": import$({
        offset: -200
      }, slide),
      "slide-btt": import$({
        offset: -200,
        dir: 2
      }, slide),
      "slide-ttb": import$({
        offset: 200,
        dir: 2
      }, slide)
    },
    edit: {
      fade: {
        'default': true,
        type: 'boolean',
        hidden: true
      },
      steep: {
        'default': 0.3,
        type: 'number',
        min: 0.3,
        max: 1,
        step: 0.01
      },
      offset: {
        name: "Move Distance",
        'default': 200,
        type: 'number',
        unit: 'px',
        min: -2000,
        max: 2000
      },
      dir: {
        'default': 1,
        type: 'number',
        hidden: true
      },
      unit: {
        'default': 'px',
        type: 'choice',
        values: ["px", "%", ""]
      }
    },
    timing: function(t, opt){
      var p1, p2;
      p1 = [opt.steep, 0, 1, 1 - opt.steep];
      p2 = [0, opt.steep, 1 - opt.steep, 1];
      if (t < 0.5) {
        t = cubic.Bezier.y(cubic.Bezier.t(t * 2, p1), p1);
      } else {
        t = cubic.Bezier.y(cubic.Bezier.t((t - 0.5) * 2, p2), p2) / 2;
        t = t * 2 - 1;
      }
      return t;
    },
    css: function(opt){
      var local, prop, ref$, ref1$, this$ = this;
      local = {
        errorThreshold: 0.0001,
        sampleCount: 20
      };
      prop = function(f, c){
        return opt.prop(f, c);
      };
      return easingFit.fitToKeyframes(function(it){
        return this$.timing(it, opt);
      }, (ref$ = (ref1$ = import$(local, opt.local) || {}, ref1$.prop = prop, ref1$.config = opt, ref1$), ref$.name = opt.name, ref$));
    },
    js: function(t, opt){
      return opt.prop({
        value: this.timing(t, opt)
      }, opt);
    },
    affine: function(t, opt){
      return opt.value(this.timing(t, opt), opt);
    }
    /* equivalent keyframes */
    /*
    slide(name, dur, rate, offset, func)
      .{name}
        animation: unquote(name) dur linear infinite
      @keyframes {name}
        0%, 100%
          timing-speed-up(rate)
        50%
          timing-speed-down(rate)
        0%
          func(0)
        49.9%
          func(offset)
        50%
          func(-1 * offset)
        100%
          func(0)
    */
  };
  if (typeof module != 'undefined' && module !== null) {
    module.exports = ret;
  }
  return ret;
})();
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}