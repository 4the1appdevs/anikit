require! <[fs fs-extra]>

types = {}
mods = fs.readdir-sync \./src/kits/
  .filter -> /\.ls$/.exec(it)
  .map -> [it.replace(/\.ls$/, ''), require("../src/kits/#it")]

mods = mods.filter -> it.0 in <[power bounce-transition jump-transition]>

for [name,mod] in mods =>
  if mod.preset => for k,v of (mod.preset or {}) => types[k] = name

load-mod = mods.map(-> """  "#{it.0}": require("./kits/#{it.0}")""").join(',\n')

fs-extra.ensure-dir-sync \dist
fs.write-file-sync "./dist/kits-list.gen.js", """
var mods = {
#load-mod
};

var types = #{JSON.stringify(types)};

module.exports = {mods: mods, types: types};
"""
