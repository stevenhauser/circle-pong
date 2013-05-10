define (require) ->

  players = require "players"
  human = require "human"
  sockets = require "sockets"

  hurtPlayers = (safePlayer) ->
    for player in players
      player.hurt() unless player is safePlayer

  updatePlayers = () ->
    socket = sockets.socket
    for player in players
      player.update()
      removePlayer(player) if player.isRotting
      socket.emit "player:updated", player.toJSON()

  removePlayer = (player) =>
    idx = players.indexOf(player)
    return unless idx > -1
    players.splice idx, 1

  endGame = () ->
    game.classList.add "over"

  tick = () ->
    ball.updateElement()
    if players.length
      # hurtPlayers() if ball.wasJustReset
      # updatePlayers()
    else
      endGame()
    requestAnimationFrame tick

  { tick: tick }
