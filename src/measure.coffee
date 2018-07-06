_ = require 'lodash'
fs = require 'fs'
Promise = require 'bluebird'
{ Parser, Builder } = require './tools'
mkdirs = require 'mkdirs'
path = require 'path'
colors = require 'colors/safe'

WIDTH_PREFIX = 'w_'
HEIGHT_PREFIX = 'h_'

convertH = (origin, TARGET_H, BASE_H ) ->
    _.round(origin * TARGET_H / BASE_H, 1)

convertW = (origin, TARGET_W, BASE_W ) ->
    _.round(origin * TARGET_W / BASE_W, 1)

module.exports = ({base, source, targets, output}) ->

   [ BASE_W, BASE_H ] = base.split '*'

   Parser fs.readFileSync(source,'utf-8')
       .then (xml) ->
            targets.forEach (target) ->
              resources = _.cloneDeep xml.resources
              [ TARGET_W, TARGET_H ] = target.split '*'
              afters = resources.dimen.map (d) ->
                 measure = d['_']
                 base = measure.substring 0, measure.length - 2
                 unit = measure.substring measure.length - 2
                 if d['$'].name.startsWith(WIDTH_PREFIX)
                     d['_'] = "#{convertW(base, TARGET_W, BASE_W)}#{unit}"
                 else if d['$'].name.startsWith(HEIGHT_PREFIX)
                     d['_'] = "#{convertH(base, TARGET_H, BASE_H)}#{unit}"
                 else
                     d['_'] = "#{convertW(base, TARGET_W, BASE_W)}#{unit}"
                 return d
              xmlstr = Builder.buildObject resources
              # dir = path.join output, "values-w#{TARGET_W}dp-h#{TARGET_H}dp"
              dir = path.join output, "values-sw#{TARGET_W}dp"
              mkdirs dir
              file = path.join dir, 'dimens.xml'
              fs.writeFileSync file, xmlstr
              console.log "+ #{colors.yellow file}"
       .catch console.log
