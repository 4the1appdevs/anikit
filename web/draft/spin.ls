require! <[easing-fit ../easing]>

module.exports = do
  opt: args: [360]
  preset: 
    "spin-fast": opt: args: [1800]

  css: (opt = {}) ->
    """@keyframes #{opt.name} {
      0% { transform: rotate(0deg); animation-timing-function: ease-in-out ; }
      100% { transform: rotate(#{opt.args.0}deg); }
    }"""
  js: (t, opt={}) -> 
    t = easing.js.ease-in-out-quad(t) * opt.args[0] * Math.PI / 180
    return [Math.cos(t), Math.sin(t), -Math.sin(t), Math.cos(t), 0, 0]
  glsl: (opt = {}) ->
    ret = easing.glsl.ease-in-out-quad + """
    mat3 #{opt.name or 'spin'}(float t, int type, mat4 opt) {
      t = easeInOutQuad(t);
      t = 3.14159 * 2. * (t - floor(t)) * opt[0].x / 360.;
      mat3 mat = mat3(
        cos(t),  sin(t), 0,
       -sin(t),  cos(t), 0,
             0,       0, 1.
      );
      return mat;
    }
    """
    ret
