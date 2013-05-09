KEYS =
  37: "left"
  39: "right"

rotation = 0
p1 = document.getElementById "player-1"
p1s = p1.style

document.addEventListener "keydown", (e) ->
  return unless e.which of KEYS
  rotation += if KEYS[e.which] is "left" then 5 else -5
  p1s.webkitTransform = "rotate(#{rotation}deg)"
