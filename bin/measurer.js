// Generated by CoffeeScript 1.12.6
(function() {
  var Promise, _, colors, compute, convert, fs, handler, measure, mkdirs, path, read, write;

  _ = require('lodash');

  fs = require('fs');

  Promise = require('bluebird');

  mkdirs = require('./mkdirs');

  path = require('path');

  colors = require('colors/safe');

  convert = require('xml-js');

  read = Promise.promisify(fs.readFile);

  write = Promise.promisify(fs.writeFile);

  compute = function(source, target, base) {
    return _.round(source * target / base, 1);
  };

  measure = function(base, document, target, output) {
    var clone, dir, element, i, len, length, ref, text, unit, value;
    clone = _.cloneDeep(document);
    ref = clone.elements[0].elements;
    for (i = 0, len = ref.length; i < len; i++) {
      element = ref[i];
      text = element.elements[0].text;
      length = text.length - 2;
      value = text.substring(0, length);
      unit = text.substring(length);
      element.elements[0].text = "" + (compute(value, target, base)) + unit;
    }
    dir = path.join(output, "values-sw" + target + "dp");
    return mkdirs(dir).then(function() {
      return write(path.join(dir, 'dimens.xml'), convert.js2xml(clone, {
        spaces: 4
      }));
    }).then(function() {
      return console.log((colors.yellow('+')) + " [" + dir + "] " + (colors.green('measured.')));
    });
  };

  handler = function(arg) {
    var base, output, source, targets;
    base = arg.base, source = arg.source, targets = arg.targets, output = arg.output;
    return read(source, 'utf-8').then(function(xmlstr) {
      var document, promises, target;
      document = convert.xml2js(xmlstr, {
        ignoreComment: true,
        ignoreDeclaration: true
      });
      promises = (function() {
        var i, len, results;
        results = [];
        for (i = 0, len = targets.length; i < len; i++) {
          target = targets[i];
          results.push(measure(base, document, target, output));
        }
        return results;
      })();
      return Promise.all(promises);
    }).then(function() {
      return console.log("> " + (colors.cyan('all done.')));
    });
  };

  module.exports = function(option) {
    return handler(option);
  };

}).call(this);
