// Generated by LiveScript 1.3.1
var easingFit;
easingFit = require('easing-fit');
module.exports = {
  css: function(opt){
    opt == null && (opt = {});
    return "@keyframes " + (opt.name || 'cycle') + " {\n  0% { transform: rotate(0deg); animation-timing-function: linear; }\n  100% { transform: rotate(360deg); }\n}";
  },
  js: function(t, opt){
    opt == null && (opt = {});
    t = t * Math.PI * 2;
    return [Math.cos(t), Math.sin(t), -Math.sin(t), Math.cos(t), 0, 0];
  },
  glsl: function(opt){
    opt == null && (opt = {});
    return "mat3 " + (opt.name || 'cycle') + "(float t, int type, mat4 opt) {\n  t = 3.14159 * 2. * (t - floor(t));\n  mat3 mat = mat3(\n    cos(t),  sin(t), 0,\n   -sin(t),  cos(t), 0,\n         0,       0, 1.\n  );\n  return mat;\n}";
  }
};