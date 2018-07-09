Promise = require 'bluebird'
xml2js  = require 'xml2js'

{ parseString } = new xml2js.Parser
  trim:true

parser = Promise.promisify parseString
builder = new xml2js.Builder
  rootName: 'resources'
  xmldec:
    encoding: 'utf-8'
    standalone: null

exports.Parser = parser
exports.Builder = builder
