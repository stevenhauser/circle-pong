define (require) ->

  User = require "user"

  game = document.getElementById "game"

  players = [new User]

  for player in players
    game.appendChild player.el
    player.appended()



  tick = () ->
    player.update() for player in players
    requestAnimationFrame tick

  tick()
