require! <[fs fs-extra ../src/anikit easing-fit]>
output = []
gn = ["No Animation", "Popular Animation", "Repeat Animation", "Transition"]
gs = [[],[],[],[]]
pop = <[spin bounce bounce-in bounce-out blink fade breath tremble slide-ltr float-btt-in flip-h]>
for k,v of anikit.types => 
  idx = if k == \static => 0 else if /\-(on|off|in|out)$/.exec(k) => 3 else 2
  gs[idx].push k
  if k in pop => gs.1.push k
gs.map -> it.sort (a,b) -> if a > b => 1 else if b > a => -1 else 0

animation = group-name: gn, members: gs

output = """
//- module
- var anikit = #{JSON.stringify(animation)};
#{fs.read-file-sync '../src/ldap.pug' .toString!}
"""
console.log output
