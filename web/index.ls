menu = document.querySelector \.dropdown-menu
btn = document.querySelector '.dropdown .btn'
sample = menu.childNodes.0.cloneNode true
s = menu.childNodes.0
s.parentNode.removeChild s

names = [k for k of anikit.types]
gs = [[],[],[],[]]
gn = ["No Animation", "Popular Animation", "Repeat Animation", "Transition"]

for k in names => 
  idx = if k == \static => 0 else if /\-(on|off|in|out)$/.exec(k) => 3 else 2
  gs[idx].push k
  if k in <[bounce bounce-in bounce-out fade blink tremble spin pulse]> => gs.1.push k

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
  if i < 3 =>
    n = document.createElement("div")
    n.classList.add \dropdown-divider
    menu.appendChild n

local = {}
menu.addEventListener \click, (e) ->
  if e.target.classList.contains \dropdown-item =>
    if local.active => that.classList.remove \active
    e.target.classList.add \active
    local.active = e.target
    console.log e.target
    btn.innerText = e.target.getAttribute \data-name
