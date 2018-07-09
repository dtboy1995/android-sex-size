fs = require 'fs'
shortid = require 'shortid'
uuidv4 = require 'uuid/v4'
colors = require 'colors/safe'
{ Parser, Builder } = require './tools'
format = require 'xml-formatter'
dimensxml =
  dimen: []

handle = (dom) ->
  for k, v of dom
    if typeof v is 'object'
      handle v
    else
      if v.endsWith('dp') > 0 or v.endsWith('sp') > 0
        name = "z#{uuidv4().replace(/\-/g,'')}"
        attr =
          _: v
          $: name: name
        dimensxml.dimen.push attr
        dom[k] = "@dimens/#{name}"

module.exports = (file) ->
  xml = fs.readFileSync file, 'utf-8'
  Parser xml
    .then (res) ->
        dimensxml.dimen = []
        handle res
        outxmlstr = Builder.buildObject res
        dimensxmlstr = Builder.buildObject dimensxml
        fs.writeFileSync "#{process.cwd()}/out.xml", format(outxmlstr.replace(/<resources>/g, '').replace(/<\/resources>/g, ''))
        fs.writeFileSync "#{process.cwd()}/dimens.xml", dimensxmlstr
        console.log "+ #{colors.yellow('[out.xml]')} #{colors.yellow('[dimens.xml]')} success"
    .catch (err) ->
        console.log err
