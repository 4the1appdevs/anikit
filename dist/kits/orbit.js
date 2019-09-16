// Generated by LiveScript 1.3.1
(function(){
  var easingFit, cubic, anikit, ret;
  if (typeof require != 'undefined' && require !== null) {
    easingFit = require('easing-fit');
    cubic = require('cubic');
    anikit = require('../anikit');
  }
  ret = {
    name: 'orbit',
    type: 'animation',
    preset: {
      orbit: {
        count: 12,
        radius: 60,
        unit: 'px'
      }
    },
    edit: {
      count: {
        name: "Sample Count",
        'default': 8,
        type: 'number',
        min: 4,
        max: 36
      },
      radius: {
        'default': 60,
        type: 'number',
        unit: '%',
        min: 0,
        max: 1000
      },
      unit: {
        'default': 'px',
        type: 'choice',
        values: ["px", "%", ""]
      }
    },
    css: function(opt){
      var list, i$, to$, i, r, a, x, y, p;
      list = [];
      for (i$ = 0, to$ = opt.count; i$ <= to$; ++i$) {
        i = i$;
        r = 360 * i / opt.count;
        a = Math.PI * 2 * i / opt.count;
        x = Math.sin(a) * opt.radius;
        y = -Math.cos(a) * opt.radius;
        p = 100 * i / opt.count;
        list.push(" " + p + "% {\nanimation-timing-function: linear;\ntransform: translate(" + x + opt.unit + "," + y + opt.unit + ") rotate(" + r + "deg) } ");
      }
      return " @keyframes " + opt.name + " { " + list.join('\n') + " } ";
    },
    js: function(t, opt){
      var m;
      m = this.affine(t, opt).transform;
      m = [m[0], -m[1], m[4], -m[5], m[3], -m[7]];
      return {
        transform: "matrix(" + m.join(',') + ")"
      };
    },
    affine: function(t, opt){
      var a, x, y;
      a = Math.PI * 2 * t;
      x = Math.sin(a) * opt.radius;
      y = -Math.cos(a) * opt.radius;
      return {
        transform: [Math.cos(a), Math.sin(a), 0, x, -Math.sin(a), Math.cos(a), 0, -y, 0, 0, 1, 0, 0, 0, 0, 1]
      };
    }
  };
  if (typeof module != 'undefined' && module !== null) {
    module.exports = ret;
  }
  return ret;
})();