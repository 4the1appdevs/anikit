module.exports = do
  opt: {args: [-40, 50, 13/18, 0.6]}
  step: (t, opt = {}) ->
    args = opt.args or []
    if t < args.2 =>
      t = t / args.2
      y = args.0 * (0.25 - (t - 0.5) ** 2) * 4
      s = 1
    else
      t = (t - args.2) / (1 - args.2) 
      s = args.3 + (1 - args.3) * ((t - 0.5) ** 2) / 0.25
      y = args.1 * (1 - s)
    return [ 1, 0, 0, s, 0, y ]
  css: (opt) ->
    opt-alt = {} <<< @opt <<< JSON.parse(JSON.stringify(opt))
    opt-alt.args.0 = 1
    args = opt.args
    ret1 = easing-fit.fit (~> @step(it, opt-alt).5), {end: args.2}
    ret2 = easing-fit.fit (~> @step(it, opt-alt).3), {start: args.2}
    ret1.pop!
    ret = ret1 ++ ret2
    ret = easing-fit.to-keyframes ret, do
      format: \css
      propFunc: (it, idx) -> 
        if idx < ret1.length =>
          ["transform: translate(0,#{it.value * args.0}px) scaleY(1)"]
        else
          s = it.value
          y = (args.1 or 50) * (1 - s)
          ["transform: translate(0,#{y}px) scaleY(#{it.value})"]
      name: opt.name or \bounce
    return ret

  js: (t, opt={}) ->
    opt = {} <<< @opt <<< opt
    mat = @step t, opt
    return mat

  glsl: (opt={})->
    """
    mat3 #{opt.name or 'bounce'}(float t, int type, mat4 opt) {
      float y, s = 1.;
      if(t < opt[0].z) {
        t = t / opt[0].z;
        y = opt[0].x * (0.25 - pow(t - 0.5, 2.)) * 4.;
      } else {
        t = (t - opt[0].z) / (1. - opt[0].z);
        s = opt[0].w + ((1. - opt[0].w) * pow(t - 0.5, 2.) / 0.25);
        y = opt[0].y * (1. - s) / s;

      }
      mat3 mat = mat3(
        1., 0., 0,
        0., 1./s, 0,
        0 , y , 1.
      );
      return mat;
    }
    """
