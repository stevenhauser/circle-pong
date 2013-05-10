define (require) ->

  ball = require "the-ball"
  Player = require "player"
  dom  = require "dom"
  human = require "human"
  players = require "players"

  findPlayer = (playerAttrs) ->
    _.find(players, (p) -> p.id is playerAttrs.id);

  removePlayer = (player) =>
    idx = players.indexOf(player)
    return unless idx > -1
    players.splice idx, 1


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

    @socket.on "game:state", (data) ->
      ball.set(data.ball)
      for playerAttrs in data.players
        player = findPlayer(playerAttrs)
        player.set(playerAttrs) if player?

    @socket.on "user:created", (data) ->
      dom.addPlayer(human)
      players.push(human)

    @socket.on "player:joined", (playerAttrs) ->
      player = new Player(playerAttrs)
      dom.addPlayer(player)
      players.push(player)
      console.log( "player:joined", playerAttrs );
      console.log( players );

    @socket.on "player:left", (playerAttrs) ->
      player = findPlayer(playerAttrs)
      player.rot() if player?
      console.log( "player:left", playerAttrs );
