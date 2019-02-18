ldap = new ldAnikitPicker do
  root: '.dropdown'
  default-filter: (d,i) -> !!/-(on|off|in|out)$/.exec(d)
  disable-filter: (d,i) -> /bounce/.exec(d)

ldap = new ldAnikitPicker do
  root: '.ldcv'
  default-filter: (d,i) -> !!/-(on|off|in|out)$/.exec(d)
  disable-filter: (d,i) -> /bounce/.exec(d)

tgt = document.querySelector '.tgt'

ldcv = new ldCover root: \.ldcv
popupit = -> ldcv.get!then -> tgt.className = "tgt ld ld-" + it
