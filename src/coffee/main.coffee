define (require) ->

  Ball = require "ball"
  human = require "human"
  players = require "players"
  theLoop = require "loop"
  sockets = require "sockets"



  # Creation

  window.human = human
  window.ball = ball = new Ball
  players.push human


  # DOM stuff

  game = document.getElementById "game"

  game.appendChild ball.el

  for player in players
    game.appendChild player.el
    player.appended()



  # Init

  sockets.initialize()
  theLoop.tick()

