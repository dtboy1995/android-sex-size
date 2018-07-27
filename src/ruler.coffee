#!/usr/bin/env coffee
fs              =     require 'fs'
pkg             =     require '../package'
measurer        =     require './measurer'
program         =     require 'commander'
colors          =     require 'colors/safe'
template        =     require './config-template'
extracter       =     require './extracter'

program
  .version pkg.version
  .description 'android screen adaptation tools'
  .option '-m, --measure [config]', 'measure targets size to output'
  .option '-e, --extract [config]', 'extract dp sp to variable'
  .option '-g, --gui', 'start gui server'
  .option '-c, --config', 'generate config.json'
  .parse process.argv

{ measure, extract, gui, config } = program

if program.rawArgs.length <= 2
   return program.help()

if config
  return template()

if extract and typeof extract is 'string'
  return extracter extract

if measure and typeof measure is 'string'
  return measurer measure
