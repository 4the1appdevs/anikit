require! <[easing-fit cubic ../anikit]>
ret = do
  name: \bounce
  type: \animation
  preset:
    bounce: {}
  edit: 
    unit: default: \px, type: \choice, values: ["px", "%", ""]
    height: default: -40, type: \number, min: -500, max: 500
    offset: default: 50, type: \number, min: -500, max: 500
    rate: default: 13/18, type: \number, min: 0, max: 1, step: 0.01
    deflate: default: 0.6, type: \number, min: 0, max: 1, step: 0.01

  step: (t, opt = {}) ->
    args = [opt.height, opt.offset, opt.rate, opt.deflate]
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
    opt-alt = JSON.parse(JSON.stringify(opt))
    opt-alt.height = 1
    ret1 = easing-fit.fit (~> @step(it, opt-alt).5), {end: opt.rate}
    ret2 = easing-fit.fit (~> @step(it, opt-alt).3), {start: opt.rate}
    ret1.pop!
    ret = ret1 ++ ret2
    ret = easing-fit.to-keyframes ret, do
      format: \css
      prop: (f, c, idx) -> 
        if idx < ret1.length =>
          {transform: "translate(0,#{f.value * c.height}px) scaleY(1)"}
        else
          s = f.value
          y = (c.offset or 50) * (1 - s)
          {transform: "translate(0,#{y}px) scaleY(#{f.value})"}
      name: opt.name
      config: opt
    return ret

  js: (t, opt) ->
    mat = @step t, opt
    return {transform: "matrix(#{mat.join(',')})"}
  
  affine: (t, opt) ->
    mat = @step t, opt
    return {transform: [mat.0, mat.1, 0, mat.4, mat.2, mat.3, 0, -mat.5, 0, 0, 1, 0, 0, 0, 0, 1]}


module.exports = ret
