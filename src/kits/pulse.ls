(->
  if require? => require! <[easing-fit cubic ../anikit]>
  ret = do
    name: \pulse
    type: \animation
    edit: do
      decay: name: "Decay", type: \number, default: 3, min: 1, max: 10, step: 1
      scale: name: "Scale", type: \number, default: 0.3, min: 0.01, max: 1, step: 0.01
    preset: pulse: {}

    track: (t, opt)->
      t = 2 * (1 - 1 * t)
      t = t - Math.floor(t)
      return Math.pow(t, opt.decay) * opt.scale + ( 1 - opt.scale / 2)

    local: prop: (f, c) -> return transform: "scale(#{f.value})"

    css: (opt) ->
      ret = easing-fit.fit-to-keyframes(
        (~> @track it, opt),
        {config: opt} <<< { 
          sample-count: 100, error-threshold: 0.0001, seg-sample-count: 100
          name: opt.name,
          prop: @local.prop
        }
      )
      ret
    js: (t, opt) -> @local.prop {value: @track t, opt}, opt

  if module? => module.exports = ret
  return ret
)!
