#!/usr/bin/env coffee
fs              =     require 'fs'
path            =     require 'path'
pkg             =     require '../package'
measurer        =     require './measurer'
program         =     require 'commander'
colors          =     require 'colors/safe'
template        =     require './config-template'
extracter       =     require './extracter'
server          =     require './server'
DEFAULT_TARGETS =     require './common'

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
  output = path.join process.cwd(), 'config.json'
  fs.writeFileSync output, template().replace('%s', DEFAULT_TARGETS)
  return console.log "#{colors.cyan '+'} [config.json] #{colors.yellow 'generated.'}"

if gui
  return server()

if extract and typeof extract is 'string'
  return read extract, 'utf-8'
           .then (option) ->
              extracter JSON.parse(option)

if measure and typeof measure is 'string'
  return read measure, 'utf-8'
           .then (option) ->
              measurer JSON.parse(option)
