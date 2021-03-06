// Generated by CoffeeScript 1.12.6
(function() {
  var SERVER_ADDR, SERVER_PORT, _, app, bodyParser, colors, dragoner, express, extracter, favicon, handler, measurer, path, template;

  _ = require('lodash');

  path = require('path');

  colors = require('colors/safe');

  express = require('express');

  bodyParser = require('body-parser');

  favicon = require('serve-favicon');

  template = require('./config-template');

  extracter = require('./extracter');

  measurer = require('./measurer');

  dragoner = require('./dragoner');

  app = express();

  SERVER_PORT = 8888;

  SERVER_ADDR = "http://localhost:" + SERVER_PORT;

  app.use(favicon(path.join(__dirname, '..', 'art', 'favicon.ico')));

  app.use(bodyParser.urlencoded({
    extended: true
  }));

  app.use(bodyParser.json());

  app.use('/', express["static"](path.join(__dirname, '..', 'art')));

  app.get('/config', function(req, res) {
    return res.send(template());
  });

  app.post('/measure', function(req, res, next) {
    return measurer(req.body).then(function() {
      return res.sendStatus(204);
    })["catch"](next);
  });

  app.post('/dragon', function(req, res, next) {
    return dragoner(req.body).then(function() {
      return res.sendStatus(204);
    })["catch"](next);
  });

  app.post('/extract', function(req, res, next) {
    return extracter(req.body).then(function() {
      return res.sendStatus(204);
    })["catch"](next);
  });

  app.use(function(req, res, next) {
    var err;
    err = new Error('Not Found');
    return next(err);
  });

  app.use(function(err, req, res, next) {
    console.log("" + (colors.red('[error]')) + err);
    return res.send({
      err: err
    });
  });

  handler = function() {
    return app.listen(SERVER_PORT, function(err) {
      if (!err) {
        return console.log((colors.green('[success]')) + " use your browser to access the " + (colors.yellow(SERVER_ADDR)));
      } else {
        throw err;
      }
    });
  };

  module.exports = handler;

}).call(this);
