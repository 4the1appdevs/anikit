// Generated by LiveScript 1.3.1
var easingFit, cubic, anikit, value, ret;
easingFit = require('easing-fit');
cubic = require('cubic');
anikit = require('../anikit');
value = function(t, c){
  var r, s, o;
  if (t < 0.6) {
    r = (t * c.rotate / 0.6) * Math.PI * 2;
    s = (1 - c.zoom) * (t / 0.6) + c.zoom;
    o = t / 0.6;
  } else {
    r = c.rotate * Math.PI * 2;
    s = 1;
    o = 1 - (t - 0.6) / (1 - 0.6);
  }
  return {
    transform: [s * Math.cos(r), s * Math.sin(r), 0, 0, -s * Math.sin(r), s * Math.cos(r), 0, 0, 0, 0, s, 0, 0, 0, 0, 1]
  };
};
ret = {
  name: 'vortex',
  type: 'animation',
  preset: {
    "vortex-out": {
      steep: 0.3,
      rotate: 5,
      zoom: 0.3,
      local: {
        sampleCount: 20,
        errorThreshold: 0.01,
        segSampleCount: 1000
      },
      prop: function(f, c){
        var v, m;
        v = value(f.value, c);
        m = anikit.util.m4to3(v.transform);
        return v.transform = "matrix(" + m.join(',') + ")", v;
      },
      value: function(t, c){
        return value(t, c);
      }
    },
    "vortex-in": {
      steep: 0.3,
      rotate: 5,
      zoom: 3,
      local: {
        sampleCount: 20,
        errorThreshold: 0.01,
        segSampleCount: 1000
      },
      prop: function(f, c){
        var v, m;
        v = value(f.value, c);
        m = anikit.util.m4to3(v.transform);
        return v.transform = "matrix(" + m.join(',') + ")", v;
      },
      value: function(t, c){
        return value(t, c);
      }
    }
  },
  edit: {
    dur: {
      'default': 2
    },
    steep: {
      'default': 0.3,
      type: 'number',
      min: 0,
      max: 0.3,
      step: 0.01
    },
    rotate: {
      'default': 5,
      type: 'number',
      min: 0,
      max: 20
    },
    zoom: {
      'default': 3,
      type: 'number',
      min: 0,
      max: 10,
      step: 0.1
    }
  },
  timing: function(t, opt){
    var p1;
    p1 = [opt.steep, 0, 1, 1 - opt.steep];
    if (t === 0) {
      return 0;
    }
    if (t < 0.6) {
      t = cubic.Bezier.y(cubic.Bezier.t(t / 0.6, p1), p1) * 0.6;
    } else {
      t = cubic.Bezier.y(cubic.Bezier.t((t - 0.6) / (1 - 0.6), p1), p1) * 0.4 + 0.6;
    }
    return t;
  },
  css: function(opt){
    var s;
    s = opt.steep;
    return "@keyframes " + opt.name + " {\n  0%, 60% {\n    animation-timing-function: cubic-bezier(" + s + ", 0, 1, " + (1 - s) + ");\n  }\n  0% {\n    opacity: 0;\n    transform: rotate(" + -360 * opt.rotate + "deg) scale(" + opt.zoom + ");\n  }\n  60% {\n    opacity: 1;\n    transform: rotate(0deg) scale(1);\n  }\n  100% { opacity: 0; }\n}";
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
    """
    @keyframes #{opt.name} {
      0% {
        timing-speed-up(config.accelerate)
        transform: rotate(360deg * config.rotate) scale(config.zoom)
        opacity: 0
      60%
        timing-speed-up(config.accelerate)
        transform: rotate(0deg) scale(1)
        opacity: 1
      100%
        opacity: 0
  
    """
  */
};
module.exports = ret;