require! <[fs fs-extra ../src/anikit easing-fit]>
output = []
gn = ["No Animation", "Popular Animation", "Repeat Animation", "Transition"]
gs = [[],[],[],[]]
gk = <[static popular repeat transition]>
g = {}
pop = <[spin bounce bounce-in bounce-out blink fade breath tremble slide-ltr float-btt-in flip-h]>
for k,v of anikit.types => 
  idx = if k == \static => 0 else if /\-(on|off|in|out)$/.exec(k) => 3 else 2
  gs[idx].push [k,anikit.mods[v].preset[k].name or k]
  if k in pop => gs.1.push k
gs.map -> it.sort (a,b) -> if a > b => 1 else if b > a => -1 else 0
for i from 0 til gk.length => g[gk[i]] = gs[i]

animation = group-name: gn, members: gs, group: g

output = """
//- module
- var anikit = #{JSON.stringify(animation)};
#{fs.read-file-sync '../src/ldap.pug' .toString!}
"""
console.log output
