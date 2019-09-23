require! <[../src/anikit]>
require! <[../src/kits/orbit]>

compatibles = <[
  orbit swim tremble blur-in blur-out metronome wander-v wander blur
  float bounce-alt jump hit shake-v shake jelly bounce
  rush-ltr rush-rtl rush-ttb rush-btt rush-ltr-in rush-rtl-in rush-ttb-in
  throw-ttb-in throw-ltr-in throw-rtl-in throw-btt-in
]>
loading-css = {}
for k in compatibles => loading-css[k] = {unit: \%}

for k,v of loading-css =>
  kit = anikit.get k
  config = kit.config <<< v
  ret = kit.css kit.config
