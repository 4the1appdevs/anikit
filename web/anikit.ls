require! <[easing-fit ./kits-list ./easing]>

anikit = do
  step-to-keyframes: (step, opt) ->
    ret = easing-fit.fit step, opt
    propFunc = opt.propFunc or (-> it)
    ret = easing-fit.to-keyframes ret, do
      name: opt.name, propFunc: (-> propFunc(it, opt)), format: \css
    return ret
  use: (name) ->
    mod = if @types[name] => @mods[@types[name]] else @mods[name]
    config = {name: name}
    for k,v of mod.edit => config[k] = v.default
    config <<< mod.preset[name]
    return {mod, config}

anikit <<< kits-list
anikit.timing = easing

if window? =>
  window.anikit = anikit
  window.easingFit = easing-fit

if module? => module.exports = anikit
