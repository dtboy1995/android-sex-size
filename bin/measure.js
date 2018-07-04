// Generated by CoffeeScript 1.12.6
(function() {
  var Builder, HEIGHT_PREFIX, Parser, Promise, WIDTH_PREFIX, _, colors, convertH, convertW, fs, mkdirs, path, ref;

  _ = require('lodash');

  fs = require('fs');

  Promise = require('bluebird');

  ref = require('./tools'), Parser = ref.Parser, Builder = ref.Builder;

  mkdirs = require('mkdirs');

  path = require('path');

  colors = require('colors/safe');

  WIDTH_PREFIX = 'w_';

  HEIGHT_PREFIX = 'h_';

  convertH = function(origin, TARGET_H, BASE_H) {
    return _.round(origin * TARGET_H / BASE_H, 1);
  };

  convertW = function(origin, TARGET_W, BASE_W) {
    return _.round(origin * TARGET_W / BASE_W, 1);
  };

  module.exports = function(arg) {
    var BASE_H, BASE_W, base, output, ref1, source, targets;
    base = arg.base, source = arg.source, targets = arg.targets, output = arg.output;
    ref1 = base.split('*'), BASE_W = ref1[0], BASE_H = ref1[1];
    return Parser(fs.readFileSync(source, 'utf-8')).then(function(xml) {
      return targets.forEach(function(target) {
        var TARGET_H, TARGET_W, afters, dir, file, ref2, resources, xmlstr;
        resources = _.cloneDeep(xml.resources);
        ref2 = target.split('*'), TARGET_W = ref2[0], TARGET_H = ref2[1];
        afters = resources.dimen.map(function(d) {
          var measure, unit;
          measure = d['_'];
          base = measure.substring(0, measure.length - 2);
          unit = measure.substring(measure.length - 2);
          if (d['$'].name.startsWith(WIDTH_PREFIX)) {
            d['_'] = "" + (convertW(base, TARGET_W, BASE_W)) + unit;
          } else if (d['$'].name.startsWith(HEIGHT_PREFIX)) {
            d['_'] = "" + (convertH(base, TARGET_H, BASE_H)) + unit;
          } else {
            d['_'] = "" + (convertW(base, TARGET_W, BASE_W)) + unit;
          }
          return d;
        });
        xmlstr = Builder.buildObject(resources);
        dir = path.join(output, "values-w" + TARGET_W + "dp-h" + TARGET_H + "dp");
        mkdirs(dir);
        file = path.join(dir, 'dimens.xml');
        fs.writeFileSync(file, xmlstr);
        return console.log("+ " + (colors.yellow(file)));
      });
    })["catch"](console.log);
  };

}).call(this);
