_         =   require 'lodash'
fs        =   require 'fs'
Promise   =   require 'bluebird'
mkdirs    =   require './mkdirs'
path      =   require 'path'
colors    =   require 'colors/safe'
convert   =   require 'xml-js'

read      =   Promise.promisify fs.readFile
write     =   Promise.promisify fs.writeFile

compute   =   (source, target, base) -> _.round source * target / base, 1

measure = (base, document, target, output) ->
  clone = _.cloneDeep document
  for element in clone.elements[0].elements
    { text } = element.elements[0]
    length = text.length - 2
    value = text.substring 0, length
    unit = text.substring length
    element.elements[0].text = "#{compute value, target, base}#{unit}"
  dir = path.join output, "values-sw#{target}dp"
  mkdirs dir
    .then ->
      write path.join(dir, 'dimens.xml'), convert.js2xml(clone, spaces: 4)
    .then () ->
      console.log "#{colors.yellow '+'} [#{dir}] #{colors.green 'measured.'}"

handler = ({ base, source, targets, output }) ->
  read source, 'utf-8'
   .then (xmlstr) ->
     document = convert.xml2js xmlstr
     promises = for target in targets
       measure base, document, target, output
     Promise.all promises
   .then ->
     console.log "> #{colors.cyan('all done.')}"

module.exports = (config) ->
  read config, 'utf-8'
    .then (option) ->
      handler JSON.parse(option)
