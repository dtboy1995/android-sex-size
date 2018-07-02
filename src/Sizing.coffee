_ = require 'lodash'
fs = require 'fs'
Promise = require 'bluebird'
{ Parser, Builder } = require './XML'
mkdirs = require 'mkdirs'

TARGET_W = 0
TARGET_H = 0
BASE_W = 0
BASE_H = 0

__SWAP__ = () ->
    tmpW = BASE_W
    tmpH = BASE_H
    BASE_W = TARGET_W
    BASE_H = TARGET_H
    TARGET_W = tmpW
    TARGET_H = tmpH

__SWAP__()

WIDTH_PREFIX = 'w_'
HEIGHT_PREFIX = 'h_'
WH_PREFIX = 'wh_'

convertH = (origin) ->
    _.round(origin * TARGET_H / BASE_H, 1)

convertW = (origin) ->
    _.round(origin * TARGET_W / BASE_W, 1)


module.exports = ({base, source, target, output}) ->

   [ BASE_W, BASE_H ] = base.split '*'
   [ TARGET_W, TARGET_H ] = target.split '*'

   Parser fs.readFileSync(source,'utf8')
       .then ({resources}) ->
           afters = resources.dimen.map (d) ->
               measure = d['_']
               base = measure.substring 0, measure.length - 2
               unit = measure.substring measure.length - 2
               if d['$'].name.startsWith(WIDTH_PREFIX)
                   d['_'] = "#{convertW(base)}#{unit}"
               else if d['$'].name.startsWith(HEIGHT_PREFIX)
                   d['_'] = "#{convertH(base)}#{unit}"
               else
                   d['_'] = "#{convertW(base)}#{unit}"
               return d
           Builder.buildObject(resources)
       .then (xmlstr) ->
           dir = "#{output}/values-sw#{TARGET_W}dp/"
           mkdirs dir
           fs.writeFileSync "#{dir}dimens.xml", xmlstr
           console.log "generated success! [#{dir}]"
       .catch (err) ->
         console.log "generate failed. due to: #{err}"
