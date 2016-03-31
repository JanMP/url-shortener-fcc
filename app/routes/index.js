'use strict';

var path = process.cwd();
var urlHandlerF = require(path + '/app/controllers/urlHandler.server.js');

module.exports = function (app, passport) {

  var urlHandler = urlHandlerF();
  
  app.route('/')
    .get(function (req, res) {
      res.sendFile(path + '/public/index.html');
    });
    
  app.route('/new/*')
    .get(urlHandler.set);
    
  app.route('/:num')
    .get(urlHandler.get);
};
