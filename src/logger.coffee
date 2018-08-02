DEBUG   =   true

module.exports = class Logger

  @debug : (message) ->
    return unless DEBUG
    jsonstr = JSON.stringify msg, null, 2
    console.log jsonstr

  @info : (message) ->
    console.log message
