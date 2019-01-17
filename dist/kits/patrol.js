// Generated by LiveScript 1.3.1
var easingFit, cubic, anikit, ret;
easingFit = require('easing-fit');
cubic = require('cubic');
anikit = require('../anikit');
ret = {
  name: 'patrol',
  type: 'animation',
  preset: {
    breath: {
      steep: 0.6,
      offset: 0.06,
      prop: function(f, c){
        return {
          transform: "scale(" + (1 + f.value * c.offset - 0.03) + ")"
        };
      },
      value: function(t, c){
        return {
          transform: anikit.util.s(1 + t * c.offset - 0.03)
        };
      }
    },
    dim: {
      steep: 0.6,
      offset: 0.5,
      prop: function(f, c){
        return {
          opacity: 0.5 + f.value * c.offset
        };
      },
      value: function(t, c){
        return {
          opacity: 0.5 + t * c.offset
        };
      }
    },
    metronome: {
      steep: 0.6,
      offset: 10,
      rotate: 30,
      unit: 'px',
      local: {
        errorThreshold: 0.001,
        sampleCount: 20,
        segSampleCount: 1000
      },
      prop: function(f, c){
        return {
          transform: "translate(" + f.value * c.offset + c.unit + ") rotate(" + f.value * c.offset * 2 + "deg)"
        };
      },
      value: function(t, c){
        var a;
        a = t * c.rotate * Math.PI / 180;
        return {
          transform: [Math.cos(a), Math.sin(a), 0, t * c.offset, -Math.sin(a), Math.cos(a), 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]
        };
      }
    },
    swing: {
      steep: 0.6,
      offset: 30,
      unit: '',
      prop: function(f, c){
        return {
          transform: "rotate(" + f.value * c.offset + "deg)"
        };
      },
      value: function(t, c){
        return {
          transform: anikit.util.rz(t * c.offset * Math.PI / 180)
        };
      }
    },
    "wander-v": {
      steep: 0.6,
      offset: 10,
      unit: 'px',
      prop: function(f, c){
        return {
          transform: "translate(0," + f.value * c.offset + c.unit + ")"
        };
      },
      value: function(t, c){
        return {
          transform: anikit.util.ty(t * c.offset)
        };
      }
    },
    wander: {
      steep: 0.6,
      offset: 10,
      unit: 'px',
      prop: function(f, c){
        return {
          transform: "translate(" + f.value * c.offset + c.unit + ",0)"
        };
      },
      value: function(t, c){
        return {
          transform: anikit.util.tx(t * c.offset)
        };
      }
    }
  },
  edit: {
    steep: {
      'default': 0.6,
      type: 'number',
      min: 0,
      max: 1,
      step: 0.01
    },
    offset: {
      'default': 10,
      type: 'number',
      unit: 'px',
      min: 0,
      max: 100,
      step: 0.01
    },
    unit: {
      'default': 'px',
      type: 'choice',
      values: ["px", "%", ""]
    }
  },
  timing: function(t, opt){
    var p;
    p = [opt.steep, 0, 1 - opt.steep, 1];
    if (t < 0.5) {
      t = cubic.Bezier.y(cubic.Bezier.t(t * 2, p), p) / 2;
    } else {
      t = cubic.Bezier.y(cubic.Bezier.t((t - 0.5) * 2, p), p) / 2 + 0.5;
    }
    t = 1 - 4 * Math.abs(t - 0.5);
    return t;
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
  @keyframes {name}
    0%,50%,100%
      timing-step(rate)
    0%
      func(-1 * max)
    50%
      func(1 * max)
    100%
      func(-1 * max)
  */
};
module.exports = ret;
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}