// Generated by LiveScript 1.3.1
(function(){
  var easingFit, cubic, anikit, ret;
  if (typeof require != 'undefined' && require !== null) {
    easingFit = require('easing-fit');
    cubic = require('cubic');
    anikit = require('../anikit');
  }
  ret = {
    name: 'blur',
    type: 'animation',
    preset: {
      blur: {}
    },
    edit: {
      blur: {
        name: "Blur Amount",
        'default': 10,
        type: 'number',
        unit: 'px',
        units: ['px', '%'],
        min: 0,
        max: 100,
        step: 1
      },
      unit: {
        'default': 'px',
        type: 'choice',
        values: ["px", "%", ""]
      }
    },
    css: function(opt){
      return "@keyframes " + opt.name + " {\n  0% { filter: blur(0) }\n  50% { filter: blur(" + opt.blur + opt.unit + ") }\n  100% { filter: blur(0) }\n}";
    },
    js: function(t, opt){
      return {
        filter: "blur(" + opt.blur * (1 - Math.abs(t - 0.5) * 2) + opt.unit + ")"
      };
    }
  };
  if (typeof module != 'undefined' && module !== null) {
    module.exports = ret;
  }
  return ret;
})();