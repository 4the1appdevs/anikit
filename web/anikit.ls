require! <[easing-fit]>

spin = require './kits/spin'
bounce = require './kits/bounce'

kits = do
  spin: spin
  bounce: bounce
anikit = (name) -> return kits[name]


if window? => window.anikit = anikit
module.exports = anikit
