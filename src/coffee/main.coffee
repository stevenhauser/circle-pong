define (require) ->

  ball = require "the-ball"
  human = require "human"
  players = require "players"
  theLoop = require "loop"
  dom = require "dom"
  sockets = require "sockets"



  # Creation

  window.human = human
  window.ball = ball
  window.players = players


  # Init

  dom.addBall(ball)
  sockets.initialize()
  theLoop.tick()

