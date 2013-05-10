define (require) ->

  players = require "players"
  human = require "human"
  sockets = require "sockets"

  hurtPlayers = (safePlayer) ->
    for player in players
      player.hurt() unless player is safePlayer

  updatePlayers = () ->
    for player in players
      player.updateElement()

  removePlayer = (player) =>
    idx = players.indexOf(player)
    return unless idx > -1
    players.splice idx, 1

  endGame = () ->
    game.classList.add "over"

  tick = () ->
    ball.updateElement()
    sockets.socket.emit "player:updated", human.toJSON()
    if players.length
      updatePlayers()
    else
      endGame()
    requestAnimationFrame tick

  { tick: tick }
