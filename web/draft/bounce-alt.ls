require! <[easing-fit]>

module.exports = do
  opt: args: [-40]
  step: do
    translateY: (t) ->
      t = (0.25 - Math.abs((t - 0.5) ** 2)) * 4
  css: (opt={}) ->
    ret = easing-fit.fit ((t) ~> @step.translateY t, opt)
    ret = easing-fit.to-keyframes ret, do
      format: \css
      propFunc: -> ["transform: translate(0,#{it.value * opt.args.0}px)"]
      name: opt.name or \bounce-alt
    return ret
  js: (t, opt={}) ->
    t = @step.translateY(t, opt) * opt.args.0
    return [ 1, 0, 0, 1, 0, t ]
  glsl: (opt={})->
    """
    mat3 #{opt.name or 'bounceAlt'}(float t, int type, mat4 opt) {
      t = t - floor(t);
      t = (0.25 - pow(abs(t - 0.5), 2.)) * 4. * opt[0][0];
      mat3 mat = mat3(
        1., 0., 0,
        0., 1., 0,
        0 , t , 1.
      );
      return mat;
    }
    """
