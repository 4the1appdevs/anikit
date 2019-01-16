// Generated by LiveScript 1.3.1
var easingFit, cubic, anikit, ret;
easingFit = require('easing-fit');
cubic = require('cubic');
anikit = require('../anikit');
ret = {
  name: 'fade',
  type: 'animation',
  preset: {
    fade: {
      prop: function(f, c){
        return {
          opacity: 1 - f.value
        };
      },
      value: function(t, c){
        return {
          opacity: 1 - t
        };
      }
    }
  },
  edit: {
    dur: {
      'default': 1
    },
    steep: {
      'default': 0,
      type: 'number',
      min: 0,
      max: 0.5,
      step: 0.01
    }
  },
  timing: function(t, opt){
    var p1;
    p1 = [opt.steep, 0.5 - opt.steep, 0.5 + opt.steep, 1.0 - opt.steep];
    return t = cubic.Bezier.y(cubic.Bezier.t(t, p1), p1);
  },
  css: function(opt){
    var ref$, ref1$, this$ = this;
    return easingFit.fitToKeyframes(function(it){
      return this$.timing(it, opt);
    }, (ref$ = (ref1$ = import$({}, opt.local) || {}, ref1$.config = opt, ref1$), ref$.name = opt.name, ref$.prop = opt.prop, ref$));
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
    @keyframes ld-fade
      0%
        opacity: 1
      100%
        opacity: 0
    .ld-fade
      animation: ld-fade config.dur linear infinite
  */
};
module.exports = ret;
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}