require! <[easing-fit]>

module.exports = do
  step: do
    rotateZ: (t) -> r = Math.PI * 2 * (t - Math.floor(t))
  css: (opts = {}) ->
    """
    @keyframes #{opts.name or 'spin'} {
      0%,100% { animation-timing-function: linear }
      0% { transform: rotate(0deg); animation-timing-function: linear }
      50% { transform: rotate(180deg); animation-timing-function: linear }
      100% { transform: rotate(360deg); animation-timing-function: linear }
    }
    """
  js: (t) -> 
    r = @step.rotateZ t
    return [Math.cos(r), Math.sin(r), -Math.sin(r), Math.cos(r), 0, 0]
  glsl: (opts = {}) ->
    ret = """
    mat3 #{opts.name or 'spin'}(float t, int type, mat4 opts) {
      t = 3.14159 * 2. * (t - floor(t));
      mat3 mat = mat3(
        cos(t),  sin(t), 0,
       -sin(t),  cos(t), 0,
             0,       0, 1.
      );
      return mat;
    }
    """
    ret
