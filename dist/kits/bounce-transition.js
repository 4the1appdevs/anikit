// Generated by LiveScript 1.3.1
var easingFit, cubic, anikit, easing, spring, ret;
easingFit = require('easing-fit');
cubic = require('cubic');
anikit = require('../anikit');
easing = require('../easing');
spring = {
  prop: function(f, c, d){
    var value;
    value = this.value(f.value, c, d);
    return {
      transform: "matrix(" + anikit.util.m4to3(value.transform).join(',') + ")",
      opacity: value.opacity
    };
  },
  value: function(t, c, d){
    var sgn;
    t = c.dir > 0
      ? t
      : 1 - t;
    if (c.dir < 0 && t > 1) {
      t = 1;
    }
    t >= 0.01 || (t = 0.01);
    if (d < 3) {
      sgn = d === 1
        ? 1
        : -1;
      return {
        transform: [1, 0, 0, c.offset * (1 - t) * sgn, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1],
        opacity: t
      };
    } else {
      sgn = d === 3
        ? 1
        : -1;
      return {
        transform: [1, 0, 0, 0, 0, 1, 0, c.offset * (1 - t) * sgn, 0, 0, 1, 0, 0, 0, 0, 1],
        opacity: t
      };
    }
  }
};
ret = {
  name: 'bounce-transition',
  type: 'animation',
  preset: {
    "bounce-in-alt": {
      dir: 1,
      count: 3,
      mag: 0.1,
      extrude: 0.5,
      local: {
        sampleCount: 20,
        errorThreshold: 0.001,
        segSampleCount: 1000
      }
    },
    "bounce-out-alt": {
      dir: -1,
      count: 3,
      mag: 0.1,
      local: {
        sampleCount: 20,
        errorThreshold: 0.001,
        segSampleCount: 1000
      }
    },
    "bounce-in": {
      dir: 1,
      count: 4,
      mag: 0.2,
      extrude: 0.5,
      local: {
        sampleCount: 40,
        errorThreshold: 0.0001,
        segSampleCount: 1000
      }
    },
    "bounce-out": {
      dir: -1,
      count: 4,
      mag: 0.2,
      local: {
        sampleCount: 20,
        errorThreshold: 0.001,
        segSampleCount: 1000
      }
    },
    "spring-ltr-in": {
      dir: 1,
      count: 3,
      mag: 0.2,
      extrude: 0.5,
      offset: 50,
      local: {
        sampleCount: 20,
        errorThreshold: 0.001,
        segSampleCount: 1000
      },
      prop: function(f, c){
        return spring.prop(f, c, 2);
      },
      value: function(t, c){
        return spring.value(t, c, 2);
      }
    },
    "spring-rtl-in": {
      dir: 1,
      count: 3,
      mag: 0.2,
      extrude: 0.5,
      offset: 50,
      local: {
        sampleCount: 20,
        errorThreshold: 0.001,
        segSampleCount: 1000
      },
      prop: function(f, c){
        return spring.prop(f, c, 1);
      },
      value: function(t, c){
        return spring.value(t, c, 1);
      }
    },
    "spring-ttb-in": {
      dir: 1,
      count: 3,
      mag: 0.2,
      extrude: 0.5,
      offset: 50,
      local: {
        sampleCount: 20,
        errorThreshold: 0.001,
        segSampleCount: 1000
      },
      prop: function(f, c){
        return spring.prop(f, c, 3);
      },
      value: function(t, c){
        return spring.value(t, c, 3);
      }
    },
    "spring-btt-in": {
      dir: 1,
      count: 3,
      mag: 0.2,
      extrude: 0.5,
      offset: 50,
      local: {
        sampleCount: 20,
        errorThreshold: 0.001,
        segSampleCount: 1000
      },
      prop: function(f, c){
        return spring.prop(f, c, 4);
      },
      value: function(t, c){
        return spring.value(t, c, 4);
      }
    },
    "throw-ltr-in": {
      dir: 1,
      count: 2,
      mag: 0.08,
      extrude: 0.5,
      offset: 500,
      'throw': true,
      local: {
        sampleCount: 20,
        errorThreshold: 0.001,
        segSampleCount: 1000
      },
      prop: function(f, c){
        return spring.prop(f, c, 2);
      },
      value: function(t, c){
        return spring.value(t, c, 2);
      }
    },
    "throw-rtl-in": {
      dir: 1,
      count: 2,
      mag: 0.08,
      extrude: 0.5,
      offset: 500,
      'throw': true,
      local: {
        sampleCount: 20,
        errorThreshold: 0.001,
        segSampleCount: 1000
      },
      prop: function(f, c){
        return spring.prop(f, c, 1);
      },
      value: function(t, c){
        return spring.value(t, c, 1);
      }
    },
    "throw-ttb-in": {
      dir: 1,
      count: 2,
      mag: 0.08,
      extrude: 0.5,
      offset: 500,
      'throw': true,
      local: {
        sampleCount: 20,
        errorThreshold: 0.001,
        segSampleCount: 1000
      },
      prop: function(f, c){
        return spring.prop(f, c, 3);
      },
      value: function(t, c){
        return spring.value(t, c, 3);
      }
    },
    "throw-btt-in": {
      dir: 1,
      count: 2,
      mag: 0.08,
      extrude: 0.5,
      offset: 500,
      'throw': true,
      local: {
        sampleCount: 20,
        errorThreshold: 0.001,
        segSampleCount: 1000
      },
      prop: function(f, c){
        return spring.prop(f, c, 4);
      },
      value: function(t, c){
        return spring.value(t, c, 4);
      }
    }
  },
  edit: {
    dir: {
      type: 'number',
      'default': 1,
      hidden: true
    },
    count: {
      type: 'number',
      'default': 30,
      min: 0,
      max: 100,
      step: 0.1
    },
    mag: {
      type: 'number',
      'default': 0.3,
      min: 0,
      max: 1,
      step: 0.01
    },
    extrude: {
      type: 'number',
      'default': 0,
      min: 0,
      max: 1,
      step: 0.01
    },
    offset: {
      type: 'number',
      'default': 0,
      min: -300,
      max: 300,
      step: 1
    },
    'throw': {
      type: 'boolean',
      'default': false
    },
    repeat: {
      'default': 1
    }
  },
  local: {
    prop: function(f, c){
      var value;
      value = this.value(f.value, c);
      return {
        transform: "matrix(" + anikit.util.m4to3(value.transform).join(',') + ")"
      };
    },
    value: function(t, c){
      t = c.dir > 0
        ? t
        : 1 - t;
      if (c.dir < 0 && t > 1) {
        t = 1;
      }
      t >= 0.01 || (t = 0.01);
      return {
        transform: [t, 0, 0, 0, 0, t, 0, 0, 0, 0, t, 0, 0, 0, 0, 1]
      };
    }
  },
  timing: function(t, opt){
    var wave, delta;
    wave = Math.cos(t * 6.28 * opt.count) * (1 - Math.pow(t, opt.mag));
    delta = 1 - Math.pow(t, opt.mag * (1 - opt.extrude));
    if (opt['throw'] && t > 0.5 / opt.count) {
      wave = -Math.abs(wave);
    }
    return 1 - (wave + delta);
  },
  css: function(opt){
    var prop, ret, ref$, ref1$, ref2$, this$ = this;
    prop = function(f, c){
      if (opt.prop) {
        return opt.prop(f, c);
      } else {
        return this$.local.prop(f, c);
      }
    };
    ret = easingFit.fitToKeyframes(function(it){
      return this$.timing(it, opt);
    }, (ref$ = (ref1$ = (ref2$ = import$({}, opt.local) || {}, ref2$.config = opt, ref2$), ref1$.name = opt.name, ref1$), ref$.prop = prop, ref$));
    return ret;
  },
  js: function(t, opt){
    var value, ret;
    value = this.affine(t, opt);
    ret = {};
    if (value.transform) {
      ret.transform = "matrix(" + anikit.util.m4to3(value.transform).join(',') + ")";
    }
    if (value.opacity) {
      ret.opacity = value.opacity;
    }
    return ret;
  },
  affine: function(t, opt){
    t = this.timing(t, opt);
    return opt.value
      ? opt.value(t, opt)
      : this.local.value(t, opt);
  }
};
module.exports = ret;
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}