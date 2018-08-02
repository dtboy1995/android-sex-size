_         =   require 'lodash'
fs        =   require 'fs'
uid       =   require 'uid'
colors    =   require 'colors/safe'
glob      =   require 'glob'
mkdirs    =   require './mkdirs'
convert   =   require 'xml-js'
logger    =   require './logger'
Promise   =   require 'bluebird'
read      =   Promise.promisify fs.readFile
write     =   Promise.promisify fs.writeFile
measure   =   require './measurer'

expect        =   (v) -> /^-?\d+((\.?\d+(dp|sp))|(dp|sp))$/.test v
DECLARATION   =   '<?xml version="1.0" encoding="utf-8"?>'
SEED          =   10
duplicate     =   false
names         =   {}
CHARSET       =   'utf-8'

dispatcher = (file, elements, counter) ->
  read file, 'utf-8'
    .then (xmlstr) ->
      document = convert.xml2js xmlstr
      parser document, elements, counter
      xmloutstr = convert.js2xml document,
          indentAttributes: true
          ignoreDeclaration: true
          spaces: 4
      write file, "#{DECLARATION}#{xmloutstr}"

parser = (document, elements, counter) ->
  for key, value of document
    if _.isArray value
      for v in value
        parser v, elements, counter
    else if _.isObject value
      parser value, elements, counter
    else
      if expect value
        counter.value++
        name = "ithot#{uid(SEED)}"
        elements.push
          type: 'element'
          name: 'dimen'
          attributes:
            name: name
          elements: [
            type: 'text'
            text: value
          ]
        document[key] = "@dimen/#{name}"

handler = ({ base, targets, dragon }) ->
  files = glob.sync "#{dragon}/src/main/res/**/!(dimens).xml"

  dimens =
    declaration:
      attributes:
        version: '1.0'
        encoding: 'utf-8'
    elements: [
      type: 'element'
      name: 'resources'
      elements: []
    ]
  dimensfile = "#{dragon}/src/main/res/values/dimens.xml"
  # concat
  if fs.existsSync dimensfile
    dimenstr = fs.readFileSync dimensfile, CHARSET
    dimensxml = convert.xml2js dimenstr,
        ignoreComment: true
        ignoreDeclaration: true
    if dimensxml.elements[0].elements?
      dimens.elements[0].elements = dimensxml.elements[0].elements
  # extract
  counter = value: 0
  promises = for file in files
    dispatcher file, dimens.elements[0].elements, counter
  Promise
    .all promises
    .then ->
      write "#{dimensfile}", convert.js2xml( dimens, spaces: 4 )
    .then ->
      logger.info "> extract #{colors.yellow counter.value} values to #{colors.cyan 'dimens.xml'} all done."
      option =
        base: base
        source: dimensfile
        targets: targets
        output: "#{dragon}/src/main/res/"
      measure option

module.exports = (option) ->
  handler option
