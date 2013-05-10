define (require) ->

  players = require "players"

  hurtPlayers = (safePlayer) ->
    for player in players
      player.hurt() unless player is safePlayer

  updatePlayers = () ->
    for player in players
      player.update()
      removePlayer(player) if player.isRotting

  removePlayer = (player) =>
    idx = players.indexOf(player)
    return unless idx > -1
    players.splice idx, 1

  endGame = () ->
    game.classList.add "over"

  tick = () ->
    if players.length
      ball.update(players)
      hurtPlayers() if ball.wasJustReset
      updatePlayers()
      requestAnimationFrame tick
    else
      endGame()

  { tick: tick }
