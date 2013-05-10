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

  removePlayer = function (player) {
    idx = players.indexOf(player)
    if (idx < 0) { return; }
    players.splice(idx, 1);
  }

  tick = function() {
    ball.update(players);
    if (ball.wasJustReset) { hurtPlayers(); }
    updatePlayers();
  }

  setInterval(tick, 100);
});




app.use( express.static(__dirname + "/..") );
app.listen(3000);
console.log( "Listening on 3000" );



io.sockets.on("connection", function(socket) {

  socket.on("player:updated", function(data) {
    console.log( "player:updated", data );
  });

});
