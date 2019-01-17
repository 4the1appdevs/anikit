require! <[easing-fit cubic ../anikit]>
ret = do
  name: \static
  type: \animation
  preset: static: {}
  edit: {}
  css: (opt) -> """ @keyframes #{opt.name} { 0% { } 100% { } } """
  js: (t, opt) -> return {}
  affine: (t, opt) -> return {}

module.exports = ret
