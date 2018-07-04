#!/usr/bin/env coffee

measure = require './measure'
program = require 'commander'
fs = require 'fs'
pkj = require '../package.json'
genTemplate = require './gen-template'
colors = require 'colors/safe'

program
  .version pkj.version
  .description 'android screen adaptive use dimens use [w_, h_] prefix'
  .option '-b, --base [base]', 'base width height dp defaults to 360*640'
  .option '-s, --source <source>', 'source path'
  .option '-t, --target <target>', 'target width height dp'
  .option '-o, --output <output>', 'destination path'
  .option '-c, --config [config]', 'config file path'
  .option '--sample', 'output a sample'
  .option '--template', 'generate config file template'
  .parse process.argv

{ base, target, template, config, sample } = program

if template
  return genTemplate()

if sample?
  return console.log "> #{colors.cyan('adaptive')} -b 360*640 -s dimens.xml -t 533*853 -o ."

if config?
  confstr = fs.readFileSync config, 'utf-8'
  confobj = JSON.parse confstr
  return measure confobj

unless base?
  program.base = '360*640'

program.targets = [ target ]

if program.rawArgs.length <= 2
  return program.help()

measure program