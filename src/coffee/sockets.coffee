define (require) ->

  ball = require "the-ball"


  # Return

  socketPort: 3001

  socket: null

  initialize: () ->
    @socket = io.connect @buildSocketUrl()
    @bindSocketEvents()
    @

  buildSocketUrl: () ->
    l = window.location
    "#{l.protocol}//#{l.hostname}:#{@socketPort}"

  bindSocketEvents: () ->
    @socket.on "connect", (data) ->
      console.log( "connect", data );

    @socket.on "game:state", (data) ->
      ball.set(data.ball)
