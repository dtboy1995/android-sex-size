fs        =   require 'fs'
path      =   require 'path'
Promise   =   require 'bluebird'

_mkdirs = (dirname, callback) ->
  fs.exists dirname, (exists) ->
    if exists
      callback()
    else
      p = path.dirname dirname
      _mkdirs p, ()->
        fs.mkdir dirname, callback


mkdirs = (dirname) ->
  new Promise (resolve, reject) ->
    _mkdirs dirname, (err) ->
      if (err)
        reject err
      else
        resolve()

module.exports = mkdirs
