#!/usr/bin/env node
// Generated by CoffeeScript 1.12.6
(function() {
  var Promise, colors, config, dragon, dragoner, extract, extracter, fs, gui, measure, measurer, output, path, pkg, program, read, server, template;

  fs = require('fs');

  path = require('path');

  pkg = require('../package');

  measurer = require('./measurer');

  program = require('commander');

  Promise = require('bluebird');

  colors = require('colors/safe');

  template = require('./config-template');

  extracter = require('./extracter');

  server = require('./server');

  dragoner = require('./dragoner');

  read = Promise.promisify(fs.readFile);

  program.version(pkg.version).description('android screen adaptation tools').option('-c, --config', 'generate config.json').option('-m, --measure [config]', 'measure targets size to output').option('-e, --extract [config]', 'extract dp sp to variable (operational irreversibility)').option('-g, --gui', 'start gui server').option('-d, --dragon [config]', 'a dragon service that extract and measure (operational irreversibility)').parse(process.argv);

  measure = program.measure, extract = program.extract, gui = program.gui, config = program.config, dragon = program.dragon;

  if (program.rawArgs.length <= 2) {
    return program.help();
  }

  if (config) {
    output = path.join(process.cwd(), 'config.json');
    fs.writeFileSync(output, template());
    return console.log((colors.cyan('+')) + " [config.json] " + (colors.yellow('generated.')));
  }

  if (gui) {
    return server();
  }

  if (extract && typeof extract === 'string') {
    return read(extract, 'utf-8').then(function(option) {
      return extracter(JSON.parse(option));
    });
  }

  if (dragon && typeof dragon === 'string') {
    return read(dragon, 'utf-8').then(function(option) {
      return dragoner(JSON.parse(option));
    });
  }

  if (measure && typeof measure === 'string') {
    return read(measure, 'utf-8').then(function(option) {
      return measurer(JSON.parse(option));
    });
  }

}).call(this);
