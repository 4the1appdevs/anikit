(->
  if require? => require! <[easing-fit cubic ../anikit]>


  value = (f, c)->
    [x,y] = [0, 0]
    if c.dir == 1 => y = -f.value
    if c.dir == 2 => y = f.value
    if c.dir == 3 => x = f.value
    if c.dir == 4 => x = -f.value
    return do
      transform: [
        1,0,0,(x * c.height),
        0,1,0,(y * c.height),
        0,0,1,0
        0,0,0,1
      ]
      opacity: (f.percent * 10) <? 1

  # while the use of [h,w,a] could be replaced by [1,1,1] in the following code,
  # we keep here for readability of the process of calculating the parabola.
  [h,w] = [1,1]
  a = h / (w ** 2) # a * (x - ox) ^2 + 0 * x + h = y
  ret = do
    name: \throw
    type: \animation
    preset: do
      "throw-ttb-in": dir: 2, repeat: 1
      "throw-ltr-in": dir: 4, repeat: 1
      "throw-rtl-in": dir: 3, repeat: 1
      "throw-btt-in": dir: 1, repeat: 1

    edit: do
      dir: type: \number, default: 1, hidden: true, min: 1, max: 4, step: 1
      count: name: "Bounce Count", type: \number, default: 3, min: 1, max: 10, step: 1
      height: name: "Height", type: \number, default: 20, min: 0, max: 1000, step: 1
      decay: name: "Decay", type: \number, default: 0.3, min: 0.01, max: 0.99, step: 0.01
      unit: default: \px, type: \choice, values: ["px", "%", ""]

    track: (t, opt)->
      r = opt.decay
      rr = Math.sqrt(r)
      dx = 0.2
      rin = 2
      total = 2 * w * (Math.pow(rr, opt.count) - 1) / (rr - 1)
      if t < dx => return (rin * 2 * h * total * dx / w) * Math.pow((dx - t), 0.5)
      x = (t - dx) * total / (1 - dx) 
      for i from 1 to opt.count =>
        cw = 2 * w * (Math.pow(rr, i) - 1) / (rr - 1)
        if x < cw => break
      ox = ((2 * w * (Math.pow(rr, i) - 1) / (rr - 1)) - w * Math.pow(rr, i - 1))
      ret = (a * (x - ox) ** 2 - h * Math.pow(r, i - 1))
      return ret

    local: 
      prop: (f, c) ->
        v = value f, c
        m = anikit.util.m4to3 v.transform
        return v <<< transform: "translate(#{m.4}#{c.unit},#{m.5}#{c.unit})"

    css: (opt) ->
      ret = easing-fit.fit-to-keyframes(
        (~> @track it, opt),
        {config: opt} <<< { 
          sample-count: 100, error-threshold: 0.000001, seg-sample-count: 100
          name: opt.name,
          prop: @local.prop
        }
      )
      ret
    js: (t, opt) -> @local.prop {value: @track(t, opt), percent: t}, opt
    affine: (t, opt) -> value {value: @track(t, opt), percent: t}, opt

  if module? => module.exports = ret
  return ret
)!
