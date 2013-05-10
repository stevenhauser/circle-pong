define (require) ->

  game = document.getElementById "game"


  # Return

  addBall: (ball) ->
    game.appendChild ball.el
    @

  addPlayer: (player) ->
    game.appendChild player.el
    player.appended()
    @
