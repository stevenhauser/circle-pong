var express = require("express"),
    app     = express(),
    server  = require("http").createServer(app),
    io      = require("socket.io").listen(3001)


// app.get("/", function(req, res) {
//   console.log( "get /" );
//   res.sendfile(__dirname + "/index.html")
// });

app.use( express.static(__dirname + "/..") );
app.listen(3000);
console.log( "Listening on 3000" );
