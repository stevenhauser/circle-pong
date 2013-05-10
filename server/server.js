var express   = require("express"),
    app       = express(),
    server    = require("http").createServer(app),
    io        = require("socket.io").listen(3001),
    requirejs = require("requirejs")
    _         = require("underscore");


requirejs.config({
  baseUrl: (__dirname + "/../dist/js"),
  nodeRequire: require
});

requirejs(["ball", "player", "players"], function(Ball, Player, players) {
  // Sloppily noop out element-related stuff on the server
  // since there's no DOM
  Player.prototype.createElement =
  Player.prototype.updateElement =
  Ball.prototype.createElement =
  Ball.prototype.updateElement = function() { return this; };

  ball = new Ball

  hurtPlayers = function (safePlayer) {
    players.forEach(function(player) {
      if (player !== safePlayer) { player.hurt(); }
    });
  }

  updatePlayers = function () {
    players.forEach(function(player) {
      player.update()
      if (player.isRotting) { removePlayer(player) }
    });
  }

  updatePlayer = function(clientData) {
    player = _.find(players, function(player) { return player.id === clientData.id; });
    if (!player) { return; }
    player.set(clientData);
  }

  removePlayer = function (player) {
    var idx = players.indexOf(player)
    if (idx < 0) { return; }
    players.splice(idx, 1);
  }

  broadcastState = function() {
    var state = {
      ball: ball.toJSON(),
      players: players.map(function(player) { return player.toJSON(); })
    };
    io.sockets.emit("game:state", state);
  };

  tick = function() {
    ball.update(players);
    if (ball.wasJustReset) { hurtPlayers(); }
    updatePlayers();
    broadcastState();
  }

  setInterval(tick, 1000 / 60);



  io.configure(function() {
    io.set("log level", 0);
  });

  io.sockets.on("connection", function(socket) {
    var player = new Player()
    players.push(player)
    socket.emit("user:created", player.toJSON())
    socket.broadcast.emit("player:joined", player.toJSON());

    socket.on("player:updated", function(data) {
      updatePlayer(data);
    });

    socket.on("disconnect", function() {
      if (!player) { return; }
      removePlayer(player);
      socket.broadcast.emit("player:left", player.toJSON());
    });
  }); // end sockets.on

}); // end requirejs




app.use( express.static(__dirname + "/..") );
app.listen(3000);
console.log( "Listening on 3000" );
