// Generated by LiveScript 1.3.1
var easingFit, cubic, anikit, easing, slide, flip, grow, ret;
easingFit = require('easing-fit');
cubic = require('cubic');
anikit = require('../anikit');
easing = require('../easing');
slide = {
  prop: function(f, c, d, o){
    var value;
    value = this.value(f.value, c, d, o);
    return {
      transform: "matrix(" + anikit.util.m4to3(value.transform).join(',') + ")",
      opacity: value.opacity
    };
  },
  value: function(t, c, d, o){
    var sgn, ret;
    if (c.dir > 0) {
      t = 1 - t;
    }
    if (t <= 0.01) {
      t = 0.01;
    }
    if (d < 3) {
      sgn = d === 1
        ? 1
        : -1;
      ret = {
        transform: [1, 0, 0, sgn * (1 - t) * c.offset, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]
      };
    } else {
      sgn = d === 3
        ? 1
        : -1;
      ret = {
        transform: [1, 0, 0, 0, 0, 1, 0, sgn * (1 - t) * c.offset, 0, 0, 1, 0, 0, 0, 0, 1]
      };
    }
    if (o != null) {
      ret.opacity = t;
    }
    return ret;
  }
};
flip = {
  prop: function(f, c, d){
    var value;
    value = this.value(f.value, c, d);
    return {
      transform: "matrix(" + anikit.util.m4to3(value.transform).join(',') + ")"
    };
  },
  value: function(t, c, d){
    if (c.dir > 0) {
      t = 1 - t;
    }
    if (t <= 0.01) {
      t = 0.01;
    }
    if (d === 1) {
      return {
        transform: [1, 0, 0, 0, 0, t, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]
      };
    } else {
      return {
        transform: [t, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]
      };
    }
  }
};
grow = {
  prop: function(f, c, d){
    var value, ret;
    value = this.value(f.value, c, d);
    ret = {
      transform: "matrix(" + anikit.util.m4to3(value.transform).join(',') + ")"
    };
    if (value.opacity != null) {
      ret.opacity = value.opacity;
    }
    return ret;
  },
  value: function(t, c, d){
    var o, sgn, ret;
    if (c.dir > 0) {
      t = 1 - t;
    }
    if (t <= 0.005) {
      t = 0.005;
    }
    o = t <= 0.005 ? 0 : 1;
    if (d < 3) {
      sgn = d === 1
        ? 1
        : -1;
      ret = {
        transform: [t, 0, 0, sgn * (1 - t) * c.offset, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]
      };
    } else {
      sgn = d === 3
        ? 1
        : -1;
      ret = {
        transform: [1, 0, 0, 0, 0, t, 0, sgn * (1 - t) * c.offset, 0, 0, 1, 0, 0, 0, 0, 1]
      };
    }
    ret.opacity = o;
    return ret;
  }
};
ret = {
  name: 'jump-transition',
  type: 'animation',
  preset: {
    "jump-alt-in": {
      dir: 1,
      count: 9,
      dtime: 0.85,
      decay: 0.5,
      local: {
        sampleCount: 40,
        errorThreshold: 0.0001,
        segSampleCount: 1000
      }
    },
    "jump-alt-out": {
      dir: -1,
      count: 9,
      dtime: 0.85,
      decay: 0.5,
      local: {
        sampleCount: 40,
        errorThreshold: 0.0001,
        segSampleCount: 1000
      }
    },
    "jump-in": {
      dir: 1,
      count: 3,
      local: {
        sampleCount: 20,
        errorThreshold: 0.0001,
        segSampleCount: 1000
      }
    },
    "jump-out": {
      dir: -1,
      count: 3,
      local: {
        sampleCount: 40,
        errorThreshold: 0.0001,
        segSampleCount: 1000
      }
    },
    "zoom-in": {
      dir: 1,
      count: 1,
      power: 0.25,
      local: {
        sampleCount: 40,
        errorThreshold: 0.01,
        segSampleCount: 100
      }
    },
    "zoom-out": {
      dir: -1,
      count: 1,
      power: 0.25,
      local: {
        sampleCount: 40,
        errorThreshold: 0.01,
        segSampleCount: 100
      }
    },
    "fade-in": {
      dir: 1,
      count: 1,
      power: 0.25,
      prop: function(f, c){
        return {
          opacity: c.dir > 0
            ? 1 - f.value
            : f.value
        };
      },
      value: function(t, c){
        return {
          opacity: c.dir > 0 ? 1 - t : t
        };
      }
    },
    "fade-out": {
      dir: -1,
      count: 1,
      power: 0.25,
      prop: function(f, c){
        return {
          opacity: f.value
        };
      },
      value: function(t, c){
        return {
          opacity: t
        };
      }
    },
    "grow-rtl-in": {
      dir: 1,
      count: 1,
      power: 0.25,
      local: {
        segPtrs: [0.02]
      },
      prop: function(f, c){
        return grow.prop(f, c, 1);
      },
      value: function(t, c){
        return grow.value(t, c, 1);
      }
    },
    "grow-rtl-out": {
      dir: -1,
      count: 1,
      power: 0.25,
      local: {
        segPtrs: [0.97]
      },
      prop: function(f, c){
        return grow.prop(f, c, 1);
      },
      value: function(t, c){
        return grow.value(t, c, 1);
      }
    },
    "grow-ltr-in": {
      dir: 1,
      count: 1,
      power: 0.25,
      local: {
        segPtrs: [0.02]
      },
      prop: function(f, c){
        return grow.prop(f, c, 2);
      },
      value: function(t, c){
        return grow.value(t, c, 2);
      }
    },
    "grow-ltr-out": {
      dir: -1,
      count: 1,
      power: 0.25,
      local: {
        segPtrs: [0.97]
      },
      prop: function(f, c){
        return grow.prop(f, c, 2);
      },
      value: function(t, c){
        return grow.value(t, c, 2);
      }
    },
    "grow-ttb-in": {
      dir: 1,
      count: 1,
      power: 0.25,
      local: {
        segPtrs: [0.02]
      },
      prop: function(f, c){
        return grow.prop(f, c, 3);
      },
      value: function(t, c){
        return grow.value(t, c, 3);
      }
    },
    "grow-ttb-out": {
      dir: -1,
      count: 1,
      power: 0.25,
      local: {
        segPtrs: [0.97]
      },
      prop: function(f, c){
        return grow.prop(f, c, 3);
      },
      value: function(t, c){
        return grow.value(t, c, 3);
      }
    },
    "grow-btt-in": {
      dir: 1,
      count: 1,
      power: 0.25,
      local: {
        segPtrs: [0.02]
      },
      prop: function(f, c){
        return grow.prop(f, c, 4);
      },
      value: function(t, c){
        return grow.value(t, c, 4);
      }
    },
    "grow-btt-out": {
      dir: -1,
      count: 1,
      power: 0.25,
      local: {
        segPtrs: [0.97]
      },
      prop: function(f, c){
        return grow.prop(f, c, 4);
      },
      value: function(t, c){
        return grow.value(t, c, 4);
      }
    },
    "flip-v-in": {
      dir: 1,
      count: 1,
      power: 0.25,
      prop: function(f, c){
        return flip.prop(f, c, 1);
      },
      value: function(t, c){
        return flip.value(t, c, 1);
      }
    },
    "flip-v-out": {
      dir: -1,
      count: 1,
      power: 0.25,
      prop: function(f, c){
        return flip.prop(f, c, 1);
      },
      value: function(t, c){
        return flip.value(t, c, 1);
      }
    },
    "flip-h-in": {
      dir: 1,
      count: 1,
      power: 0.25,
      prop: function(f, c){
        return flip.prop(f, c, 2);
      },
      value: function(t, c){
        return flip.value(t, c, 2);
      }
    },
    "flip-h-out": {
      dir: -1,
      count: 1,
      power: 0.25,
      prop: function(f, c){
        return flip.prop(f, c, 2);
      },
      value: function(t, c){
        return flip.value(t, c, 2);
      }
    },
    "slide-rtl-in": {
      dir: 1,
      count: 1,
      power: 0.25,
      offset: 200,
      prop: function(f, c){
        return slide.prop(f, c, 1);
      },
      value: function(t, c){
        return slide.value(t, c, 1);
      }
    },
    "slide-rtl-out": {
      dir: -1,
      count: 1,
      power: 0.25,
      offset: 200,
      prop: function(f, c){
        return slide.prop(f, c, 1);
      },
      value: function(t, c){
        return slide.value(t, c, 1);
      }
    },
    "slide-ltr-in": {
      dir: 1,
      count: 1,
      power: 0.25,
      offset: 200,
      prop: function(f, c){
        return slide.prop(f, c, 2);
      },
      value: function(t, c){
        return slide.value(t, c, 2);
      }
    },
    "slide-ltr-out": {
      dir: -1,
      count: 1,
      power: 0.25,
      offset: 200,
      prop: function(f, c){
        return slide.prop(f, c, 2);
      },
      value: function(t, c){
        return slide.value(t, c, 2);
      }
    },
    "slide-ttb-in": {
      dir: 1,
      count: 1,
      power: 0.25,
      offset: 200,
      prop: function(f, c){
        return slide.prop(f, c, 3);
      },
      value: function(t, c){
        return slide.value(t, c, 3);
      }
    },
    "slide-ttb-out": {
      dir: -1,
      count: 1,
      power: 0.25,
      offset: 200,
      prop: function(f, c){
        return slide.prop(f, c, 3);
      },
      value: function(t, c){
        return slide.value(t, c, 3);
      }
    },
    "slide-btt-in": {
      dir: 1,
      count: 1,
      power: 0.25,
      offset: 200,
      prop: function(f, c){
        return slide.prop(f, c, 4);
      },
      value: function(t, c){
        return slide.value(t, c, 4);
      }
    },
    "slide-btt-out": {
      dir: -1,
      count: 1,
      power: 0.25,
      offset: 200,
      prop: function(f, c){
        return slide.prop(f, c, 4);
      },
      value: function(t, c){
        return slide.value(t, c, 4);
      }
    },
    "float-rtl-in": {
      dir: 1,
      count: 1,
      power: 0.25,
      offset: 15,
      prop: function(f, c){
        return slide.prop(f, c, 1, 1);
      },
      value: function(t, c){
        return slide.value(t, c, 1, 1);
      }
    },
    "float-rtl-out": {
      dir: -1,
      count: 1,
      power: 0.25,
      offset: 15,
      prop: function(f, c){
        return slide.prop(f, c, 1, 1);
      },
      value: function(t, c){
        return slide.value(t, c, 1, 1);
      }
    },
    "float-ltr-in": {
      dir: 1,
      count: 1,
      power: 0.25,
      offset: 15,
      prop: function(f, c){
        return slide.prop(f, c, 2, 1);
      },
      value: function(t, c){
        return slide.value(t, c, 2, 1);
      }
    },
    "float-ltr-out": {
      dir: -1,
      count: 1,
      power: 0.25,
      offset: 15,
      prop: function(f, c){
        return slide.prop(f, c, 2, 1);
      },
      value: function(t, c){
        return slide.value(t, c, 2, 1);
      }
    },
    "float-ttb-in": {
      dir: 1,
      count: 1,
      power: 0.25,
      offset: 15,
      prop: function(f, c){
        return slide.prop(f, c, 3, 1);
      },
      value: function(t, c){
        return slide.value(t, c, 3, 1);
      }
    },
    "float-ttb-out": {
      dir: -1,
      count: 1,
      power: 0.25,
      offset: 15,
      prop: function(f, c){
        return slide.prop(f, c, 3, 1);
      },
      value: function(t, c){
        return slide.value(t, c, 3, 1);
      }
    },
    "float-btt-in": {
      dir: 1,
      count: 1,
      power: 0.25,
      offset: 15,
      prop: function(f, c){
        return slide.prop(f, c, 4, 1);
      },
      value: function(t, c){
        return slide.value(t, c, 4, 1);
      }
    },
    "float-btt-out": {
      dir: -1,
      count: 1,
      power: 0.25,
      offset: 15,
      prop: function(f, c){
        return slide.prop(f, c, 4, 1);
      },
      value: function(t, c){
        return slide.value(t, c, 4, 1);
      }
    },
    "fall-rtl-in": {
      dir: 1,
      count: 3,
      prop: function(f, c){
        return slide.prop(f, c, 1);
      },
      value: function(t, c){
        return slide.value(t, c, 1);
      }
    },
    "fall-ltr-in": {
      dir: 1,
      count: 3,
      prop: function(f, c){
        return slide.prop(f, c, 2);
      },
      value: function(t, c){
        return slide.value(t, c, 2);
      }
    },
    "fall-ttb-in": {
      dir: 1,
      count: 3,
      prop: function(f, c){
        return slide.prop(f, c, 3);
      },
      value: function(t, c){
        return slide.value(t, c, 3);
      }
    },
    "fall-btt-in": {
      dir: 1,
      count: 3,
      prop: function(f, c){
        return slide.prop(f, c, 4);
      },
      value: function(t, c){
        return slide.value(t, c, 4);
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
      'default': 5,
      min: 1,
      max: 30,
      step: 2
    },
    dtime: {
      type: 'number',
      'default': 0.7,
      min: 0,
      max: 1,
      step: 0.01
    },
    decay: {
      type: 'number',
      'default': 0.4,
      min: 0,
      max: 1,
      step: 0.01
    },
    power: {
      type: 'number',
      'default': 2,
      min: 0,
      max: 10,
      step: 0.01,
      hidden: true
    },
    offset: {
      type: 'number',
      'default': 50,
      min: 0,
      max: 100,
      step: 1
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
      if (c.dir > 0) {
        t = 1 - t;
      }
      if (t <= 0.01) {
        t = 0.01;
      }
      return {
        transform: [t, 0, 0, 0, 0, t, 0, 0, 0, 0, t, 0, 0, 0, 0, 1]
      };
    }
  },
  timing: function(t, opt){
    var pt, et, i$, to$, i, oet, delta, x;
    pt = 1 / (2 * ((Math.pow(opt.dtime, opt.count) - 1) / (opt.dtime - 1) - 0.5));
    et = 0;
    t = t + pt;
    for (i$ = 0, to$ = opt.count; i$ < to$; ++i$) {
      i = i$;
      oet = et;
      delta = pt * Math.pow(opt.dtime, i);
      et = et + 2 * delta;
      if (t <= et) {
        x = (1 - Math.pow((t - oet) - delta, opt.power) / Math.pow(delta, opt.power)) * Math.pow(opt.decay, i);
        return x;
      }
    }
    return 0;
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
    console.log(ret);
    return ret;
  },
  js: function(t, opt){
    var value, ret;
    value = this.affine(t, opt);
    ret = {};
    if (value.transform) {
      ret.transform = "matrix(" + anikit.util.m4to3(value.transform).join(',') + ")";
    }
    if (value.opacity != null) {
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