const http = require('http');
const fs = require('fs');
const { Liquid } = require('liquidjs');

const engine = new Liquid();
let data;
fs.readFile('sample_data.json', 'utf8', (err, fileData) => {
    if (err) {
        console.error(err);
        return;
    }
    data = JSON.parse(fileData);
});

http.createServer((request, response) => {
  fs.readFile('liquid.html', 'utf8', (err, template) => {
    if (err) {
      console.error(err);
      response.writeHead(500, {'Content-Type': 'text/plain'});
      response.end('An error occurred');
      return;
    }

    engine.parseAndRender(template, data)
      .then(result => {
        response.writeHead(200, {'Content-Type': 'text/html'});
        response.end(result);
      })
      .catch(err => {
        console.error(err);
        response.writeHead(500, {'Content-Type': 'text/plain'});
        response.end('An error occurred');
      });
  });
}).listen(3021, () => console.log('Server started on http://localhost:3021'));
