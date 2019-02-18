menu = document.querySelector '.dropdown-menu .in'
btn = document.querySelector '.dropdown .btn'
s = document.querySelector '.dropdown-menu .dropdown-item'
sample = s.cloneNode true
s.parentNode.removeChild s
tgt = document.querySelector '.tgt'

names = [k for k of anikit.types]
gs = [[],[],[],[]]
gn = ["No Animation", "Popular Animation", "Repeat Animation", "Transition"]

for k in names => 
  idx = if k == \static => 0 else if /\-(on|off|in|out)$/.exec(k) => 3 else 2
  gs[idx].push k
  if k in <[bounce bounce-in bounce-out fade blink tremble spin pulse]> => gs.1.push k

local = {}

ldcv = new ldCover root: '.ldcv'
popupit = -> ldcv.get!then -> 
  tgt.className = "tgt ld ld-" + it
popup = document.querySelector '.ldcv .base .inner'

local.count = 0
for i from 0 til 4 =>
  g = document.createElement("div")
  if i > 0  => popup.appendChild document.createElement("hr")
  n = document.createElement("h6")
  n.style <<< margin: "20px", color: \#444
  n.innerText = gn[i]
  popup.appendChild n
  g.classList.add \lditems
  popup.appendChild g
  for k in gs[i] =>
    node = document.createElement("div")
    node.setAttribute \data-ldcv-set, k
    node.innerHTML = """
    <div class="ldo"><div class="ldin"><div class="ld ld-#k"></div></div></div>
    <div class="name">#k</div>
    """
    node.classList.add \lditem
    if local.count > 10 => node.classList.add \disabled
    g.appendChild node
    local.count = (local.count or 0) + 1
  
local.count = 0
for i from 0 til 4 =>
  n = document.createElement("h6")
  n.classList.add \dropdown-header
  n.innerText = gn[i]
  menu.appendChild n
  for k in gs[i] => 
    node = sample.cloneNode true
    node.querySelector \span .innerText = k
    node.querySelector \.ld .classList.add "ld-#k"
    node.setAttribute \data-name, k
    menu.appendChild node
    if local.count > 10 => node.classList.add \disabled
    local.count = (local.count or 0) + 1
  if i < 3 =>
    n = document.createElement("div")
    n.classList.add \dropdown-divider
    menu.appendChild n

menu.addEventListener \click, (e) ->
  if e.target.classList.contains \dropdown-item =>
    if local.active => that.classList.remove \active
    e.target.classList.add \active
    local.active = e.target
    console.log e.target
    btn.innerText = e.target.getAttribute \data-name
