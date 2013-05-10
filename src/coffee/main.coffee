define (require) ->

  User = require "user"
  Ball = require "ball"
  players = require "players"
  theLoop = require "loop"



  # Creation

  window.user = user = new User
  window.ball = ball = new Ball
  players.push user


  # DOM stuff

  game = document.getElementById "game"

  game.appendChild ball.el

  for player in players
    game.appendChild player.el
    player.appended()



  # Init

  theLoop.tick()

