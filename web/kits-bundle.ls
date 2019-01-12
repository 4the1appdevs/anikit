require! <[fs]>

types = {}
mods = fs.readdir-sync \kits
  .filter -> /\.ls$/.exec(it)
  .map -> [it.replace(/\.ls$/, ''), require("./kits/#it")]

for [name,mod] in mods =>
  if mod.preset => for k,v of (mod.preset or {}) => types[k] = name

load-mod = mods.map(-> """  "#{it.0}": require("./kits/#{it.0}")""").join(',\n')

fs.write-file-sync "kits-list.js", """
var mods = {
#load-mod
};

var types = #{JSON.stringify(types)};

module.exports = {mods: mods, types: types};
"""
