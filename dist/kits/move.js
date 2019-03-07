// Generated by LiveScript 1.3.1
var easingFit, cubic, anikit, move, ret;
easingFit = require('easing-fit');
cubic = require('cubic');
anikit = require('../anikit');
move = {
  prop: function(f, c){
    var value;
    value = this.value(f.value, c);
    return {
      transform: "matrix(" + anikit.util.m4to3(value.transform).join(',') + ")",
      opacity: c.fade ? value.opacity : void 8
    };
  },
  value: function(t, c){
    return {
      transform: anikit.util[c.dir === 1 ? 'tx' : 'ty'](t * c.offset),
      opacity: c.fade ? t <= -0.8 || t >= 0.8 ? 0 : 1 : void 8
    };
  }
};
ret = {
  name: 'move',
  type: 'animation',
  preset: {
    "move-ltr": import$({
      offset: 200
    }, move),
    "move-rtl": import$({
      offset: -200
    }, move),
    "move-btt": import$({
      offset: -200,
      dir: 2
    }, move),
    "move-ttb": import$({
      offset: 200,
      dir: 2
    }, move)
  },
  edit: {
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
    },
    fade: {
      type: 'boolean',
      'default': false
    }
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
      return it;
    }, (ref$ = (ref1$ = import$(local, opt.local) || {}, ref1$.prop = prop, ref1$.config = opt, ref1$), ref$.name = opt.name, ref$));
  },
  js: function(t, opt){
    return opt.prop({
      value: t
    }, opt);
  },
  affine: function(t, opt){
    return opt.value(t, opt);
  }
};
module.exports = ret;
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}