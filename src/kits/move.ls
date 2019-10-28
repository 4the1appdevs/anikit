(->
  if require? => require! <[easing-fit cubic ../anikit]>
  move = do
    prop: (f, c) -> 
      value = @value f.value, c
      value.transform = anikit.util.decompose(anikit.util.m4to3(value.transform), c)
      return value
    value: (t, c) ->
      ret = do
        transform: anikit.util[if (c.dir % 2) => \tx else \ty](
          (if c.dir > 2 => -1 else 1) * ((2 * t) - (Math.floor(2 * t) * 2 <? 2)) * c.offset / 2
        )
      if c.fade => ret.opacity = anikit.util.round(Math.abs(t - 0.5) * 10 <? 1)
      return ret

  ret = do
    name: \move
    type: \animation
    preset:
      # no-fade animation is useful for seamless repeatable patterns when animating
      "move-ltr": {label: "move (left to right)", offset: 100, dir: 1} <<< move
      "move-rtl": {label: "move (right to left)", offset: 100, dir: 3} <<< move
      "move-ttb": {label: "move (top to bottom)", offset: 100, dir: 2} <<< move
      "move-btt": {label: "move (bottom to top)", offset: 100, dir: 4} <<< move
      "move-fade-ltr": {label: "move faded (left to right)", offset: 100, dir: 1, fade: true} <<< move
      "move-fade-rtl": {label: "move faded (right to left)", offset: 100, dir: 3, fade: true} <<< move
      "move-fade-ttb": {label: "move faded (top to bottom)", offset: 100, dir: 2, fade: true} <<< move
      "move-fade-btt": {label: "move faded (bottom to top)", offset: 100, dir: 4, fade: true} <<< move

    edit: 
      steep: default: 0.3, type: \number, min: 0.3, max: 1, step: 0.01
      offset: name: "Move Distance", default: 100, type: \number, unit: \px, min: 0, max: 1000
      dir: default: 1, type: \number, hidden: true
      unit: default: \px, type: \choice, values: ["px", "%", ""]
      fade: type: \boolean, default: false

    timing: (t, opt) -> (((2 * t + 1) % 2) - 1) * 0.5 + 0.5

    css: (opt) -> 
      easing-fit.to-keyframes(
        [
          {percent: 0, value: 0}
          {percent: 40, value: 0.4}
          {percent: 49.99999, value: 0.4999999}
          {percent: 50, value: 0.5}
          {percent: 50.00001, value: 0.5000001}
          {percent: 60, value: 0.6}
          {percent: 100, value: 1}
        ],
        {} <<< {prop: ((f,c)-> move.prop(f,c)), config: opt} <<< opt{name}
      )
    js: (t, opt) -> opt.prop {value: t}, opt
    affine: (t, opt) -> opt.value t, opt

  if module? => module.exports = ret
  return ret
)!
