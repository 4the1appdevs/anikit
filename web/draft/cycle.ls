require! <[easing-fit]>

module.exports = do
  css: (opt = {}) ->
    """
    @keyframes #{opt.name or 'cycle'} {
      0% { transform: rotate(0deg); animation-timing-function: linear; }
      100% { transform: rotate(360deg); }
    }
    """
  js: (t, opt={}) -> 
    t = t * Math.PI * 2
    return [Math.cos(t), Math.sin(t), -Math.sin(t), Math.cos(t), 0, 0]
  glsl: (opt = {}) ->
    """
    mat3 #{opt.name or 'cycle'}(float t, int type, mat4 opt) {
      t = 3.14159 * 2. * (t - floor(t));
      mat3 mat = mat3(
        cos(t),  sin(t), 0,
       -sin(t),  cos(t), 0,
             0,       0, 1.
      );
      return mat;
    }
    """
