// Generated by CoffeeScript 1.12.6
(function() {
  var Promise, _mkdirs, fs, mkdirs, path;

  fs = require('fs');

  path = require('path');

  Promise = require('bluebird');

  _mkdirs = function(dirname, callback) {
    return fs.exists(dirname, function(exists) {
      var p;
      if (exists) {
        return callback();
      } else {
        p = path.dirname(dirname);
        return _mkdirs(p, function() {
          return fs.mkdir(dirname, callback);
        });
      }
    });
  };

  mkdirs = function(dirname) {
    return new Promise(function(resolve, reject) {
      return _mkdirs(dirname, function(err) {
        if (err) {
          return reject(err);
        } else {
          return resolve();
        }
      });
    });
  };

  module.exports = mkdirs;

}).call(this);
