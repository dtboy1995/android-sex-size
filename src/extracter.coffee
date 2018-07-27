_         =   require 'lodash'
fs        =   require 'fs'
uid       =   require 'uid'
colors    =   require 'colors/safe'
glob      =   require 'glob'
convert   =   require 'xml-js'
Promise   =   require 'bluebird'
read      =   Promise.promisify fs.readFile
write     =   Promise.promisify fs.writeFile

SEED        =   10
duplicate   =   false # reserved
names       =   {}
expect      =   (v) -> /^[0-9]+(dp|sp)$/.test v

dispatcher = (file, elements) ->
  read file, 'utf-8'
    .then (xmlstr) ->
      document = convert.xml2js xmlstr
      parser document, elements
      write file, convert.js2xml document,
          indentAttributes: true
          spaces: 4
    .then ->
      console.log "#{colors.yellow '+'} [#{file}] #{colors.green 'extracted.'}"

parser = (document, elements) ->
  for key, value of document
    if _.isArray value
      for v in value
        parser v, elements
    else if _.isObject value
      parser value, elements
    else
      if expect value
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

handler = ({extract}) ->
  files = unless fs.lstatSync(extract).isDirectory() then [extract] else glob.sync("#{extract}/**/*.xml")
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
  promises = for file in files
    dispatcher file, dimens.elements[0].elements
  Promise
    .all promises
    .then ->
      write "#{process.cwd()}/dimens.xml", convert.js2xml(dimens, spaces: 4)
    .then ->
      console.log "> #{colors.cyan('all done.')}"

module.exports = (config) ->
  read config, 'utf-8'
    .then (option) ->
      handler JSON.parse(option)
