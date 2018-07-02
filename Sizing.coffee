Promise = require 'bluebird'
xml2js  = require 'xml2js'

{ parseString } = new xml2js.Parser
  trim:true

Parser = Promise.promisify parseString
Builder = new xml2js.Builder
  rootName: 'resources'
  xmldec:
    encoding: 'utf-8'
    standalone: null

_ = require 'lodash'
fs = require 'fs'

TARGET_W = 533
TARGET_H = 853
BASE_W = 360
BASE_H = 640

SOURCE_FILE = './source.xml'
TARGET_FILE = "./values-sw#{TARGET_W}dp/"

xml = fs.readFileSync SOURCE_FILE, 'utf8'

convertH = (origin) ->
    _.round(origin * TARGET_H / BASE_H, 1)

convertW = (origin) ->
    _.round(origin * TARGET_W / BASE_W, 1)

Parser xml
    .then ({resources}) ->
        afters = resources.dimen.map (d) ->
            measure = d['_']
            base = measure.substring 0, measure.length - 2
            unit = measure.substring measure.length - 2
            d['_'] = "#{convertH(base)}#{unit}"
            return d
        Builder.buildObject(resources)
    .then (xmlstr) ->
        unless fs.existsSync(TARGET_FILE)
            fs.mkdirSync TARGET_FILE
        fs.writeFileSync "#{TARGET_FILE}dimens.xml", xmlstr
