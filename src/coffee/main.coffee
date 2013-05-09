define (require) ->

  User = require "user"
  Ball = require "ball"


  # Creation

  window.user = user = new User
  window.ball = ball = new Ball
  players = [user]



  # DOM stuff

  game = document.getElementById "game"

  game.appendChild ball.el

  for player in players
    game.appendChild player.el
    player.appended()



  # The loop and init

  hurtPlayers = (safePlayer) ->
    for player in players
      player.hurt() unless player is safePlayer

  updatePlayers = () ->
    for player in players
      player.update()
      removePlayer(player) if player.hasBeenRemoved

  removePlayer = (player) =>
    idx = players.indexOf(player)
    return unless idx > -1
    players.splice idx, 1

  tick = () ->
    return unless players.length
    ball.update(players)
    hurtPlayers() if ball.wasJustReset
    updatePlayers()
    requestAnimationFrame tick

  tick()
