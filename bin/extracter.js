// Generated by CoffeeScript 1.12.6
(function() {
  var DECLARATION, Promise, SEED, _, colors, convert, dispatcher, duplicate, expect, fs, glob, handler, mkdirs, names, parser, read, uid, write;

  _ = require('lodash');

  fs = require('fs');

  uid = require('uid');

  colors = require('colors/safe');

  glob = require('glob');

  mkdirs = require('./mkdirs');

  convert = require('xml-js');

  Promise = require('bluebird');

  read = Promise.promisify(fs.readFile);

  write = Promise.promisify(fs.writeFile);

  SEED = 10;

  duplicate = false;

  names = {};

  expect = function(v) {
    return /^-?\d+((\.?\d+(dp|sp))|(dp|sp))$/.test(v);
  };

  DECLARATION = '<?xml version="1.0" encoding="utf-8"?>';

  dispatcher = function(file, elements) {
    return read(file, 'utf-8').then(function(xmlstr) {
      var document, xmloutstr;
      document = convert.xml2js(xmlstr);
      parser(document, elements);
      xmloutstr = convert.js2xml(document, {
        indentAttributes: true,
        ignoreDeclaration: true,
        spaces: 4
      });
      return write(file, "" + DECLARATION + xmloutstr);
    }).then(function() {
      return console.log((colors.yellow('+')) + " [" + file + "] " + (colors.green('extracted.')));
    });
  };

  parser = function(document, elements) {
    var key, name, results, v, value;
    results = [];
    for (key in document) {
      value = document[key];
      if (_.isArray(value)) {
        results.push((function() {
          var i, len, results1;
          results1 = [];
          for (i = 0, len = value.length; i < len; i++) {
            v = value[i];
            results1.push(parser(v, elements));
          }
          return results1;
        })());
      } else if (_.isObject(value)) {
        results.push(parser(value, elements));
      } else {
        if (expect(value)) {
          name = "ithot" + (uid(SEED));
          elements.push({
            type: 'element',
            name: 'dimen',
            attributes: {
              name: name
            },
            elements: [
              {
                type: 'text',
                text: value
              }
            ]
          });
          results.push(document[key] = "@dimen/" + name);
        } else {
          results.push(void 0);
        }
      }
    }
    return results;
  };

  handler = function(arg) {
    var dimens, extract, file, files, output, promises;
    extract = arg.extract, output = arg.output;
    files = !fs.lstatSync(extract).isDirectory() ? [extract] : glob.sync(extract + "/**/!(dimens).xml");
    dimens = {
      declaration: {
        attributes: {
          version: '1.0',
          encoding: 'utf-8'
        }
      },
      elements: [
        {
          type: 'element',
          name: 'resources',
          elements: []
        }
      ]
    };
    promises = (function() {
      var i, len, results;
      results = [];
      for (i = 0, len = files.length; i < len; i++) {
        file = files[i];
        results.push(dispatcher(file, dimens.elements[0].elements));
      }
      return results;
    })();
    return Promise.all(promises).then(function() {
      return mkdirs(output);
    }).then(function() {
      return write(output + "/dimens.xml", convert.js2xml(dimens, {
        spaces: 4
      }));
    }).then(function() {
      return console.log("> " + (colors.cyan('all done.')));
    });
  };

  module.exports = function(option) {
    return handler(option);
  };

}).call(this);
