const http = require('http');

function myCustomMiddleware(req, res, next) {
  const additionalParam = 'my additional parameter';
  req.additionalParam = additionalParam;
  next();
}

const server = http.createServer((req, res) => {
  // Handle incoming requests
  console.log(req.additionalParam);
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hello, World!');
});

console.log(server);

// server.use(myCustomMiddleware);

server.listen(3000, () => {
  console.log('Server running on port 3000');
});
