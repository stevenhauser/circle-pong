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
  Player.prototype.remove =
  Player.prototype.appended =
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
      if (player.isRotting) {
        removePlayer(player)
        io.sockets.emit("player:removed", player.toJSON());
      }
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

  getState = function() {
    return {
      ball: ball.toJSON(),
      players: players.map(function(player) { return player.toJSON(); })
    };
  }

  broadcastState = function() {
    io.sockets.emit("game:state", getState());
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
    socket.emit("user:created", _.extend( getState(), { user: player.toJSON() }))
    socket.broadcast.emit("player:joined", player.toJSON());
    // console.log( "player joined", players.length );

    socket.on("player:updated", function(data) {
      updatePlayer(data);
    });

    socket.on("disconnect", function() {
      if (!player) { return; }
      removePlayer(player);
      socket.broadcast.emit("player:left", player.toJSON());

      // console.log( "player left", players.length );
    });
  }); // end sockets.on

}); // end requirejs




app.use( express.static(__dirname + "/..") );
app.listen(3000);
console.log( "Listening on 3000" );
