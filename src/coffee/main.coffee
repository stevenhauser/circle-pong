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

  tick = () ->
    ball.update()
    player.update() for player in players
    requestAnimationFrame tick

  tick()
