var http = require('http');
var url  = require('url');
var fs   = require('fs');

http.createServer(function (req, res) {
  var q = url.parse(req.url, true);
  var filename = "." + q.pathname;
  console.log(filename);

  res.writeHead(200, {'Content-Type': 'text/html'});
  res.write("<h1>" + filename + "</h1>");
  res.end();
 
}).listen(8080);

