ret = do
  name: \blur
  preset:
    blur: {}
  edit: 
    blur: default: 10, type: \number, unit: \px, min: 0, max: 100
    unit: default: \px, type: \choice, values: ["px", "%", ""]

  css: (opt) ->
    """
    @keyframes #{opt.name} {
      0% { filter: blur(0) }
      50% { filter: blur(#{opt.blur}#{opt.unit}) }
      100% { filter: blur(0) }
    }
    """

  js: (t, opt) ->


module.exports = ret
