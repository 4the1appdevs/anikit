ret = do
  name: \wrench
  preset:
    wrench: {}
  edit: 
    dur: default: 1
    rotate: default: 45, type: \number, min: 0, max: 360, step: 1

  css: (opt) ->
    """
    @keyframes #{opt.name} {
      20%, 36%, 70%, 86% {
        transform: rotate(0deg);
      }
      0%, 50%, 100% {
        transform: rotate(#{opt.rotate}deg);
      }
    }
    """
  js: (t, opt) ->
    t = (t * 2 - Math.floor(t * 2)) * 0.5
    if t < 0.2 => t = 1 - (t / 0.2)
    else if t > 0.36 => t = (t - 0.36) / 0.14
    else t = 0
    return { transform: "rotate(#{t * opt.rotate}deg)" }


module.exports = ret
