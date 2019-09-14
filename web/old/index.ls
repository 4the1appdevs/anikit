ldap-dropdown = new ldAnikitPicker do
  root: '.dropdown'
  default-filter: (d,i) -> !!/-(on|off|in|out)$/.exec(d)
  disable-filter: (d,i) -> /bounce/.exec(d)

ldap-modal = new ldAnikitPicker do
  root: '.ldcv'
  default-filter: (d,i) -> !!/-(on|off|in|out)$/.exec(d)
  disable-filter: (d,i) -> /bounce/.exec(d)

tgt = document.querySelector '.tgt'

ldcv = new ldCover root: \.ldcv
popupit = -> ldcv.get!then -> tgt.className = "tgt ld ld-" + it

alert = document.createElement("div")
alert.classList.add \alert, \alert-primary, \small
alert.innerHTML = """<span>Upgrade to Unlock All</span><div class="btn btn-primary btn-sm ml-2">Subscribe Now</div>"""

ld$.find(ldcv.root, '.base', 0).appendChild alert

alert = document.createElement("div")
alert.classList.add \alert, \alert-primary, \small
alert.innerHTML = "Go Pro to Unlock All"
ld$.find(ldap-dropdown.root, '.dropdown-menu', 0).appendChild alert

ldap-dropdown.on \choose, -> tgt.className = "tgt ld ld-" + it
