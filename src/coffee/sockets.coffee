define (require) ->

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
