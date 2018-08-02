fs      =   require 'fs'
del     =   require 'del'
execa   =   require 'execa'
logger  =   require './logger'

del "bin/*.*"
  .then ->
    execa.shell "coffee --output bin/ -c src/"
  .then ->
    clistr = fs.readFileSync "bin/ruler.js", 'utf-8'
    fs.writeFileSync "bin/ruler.js", "#!/usr/bin/env node\n#{clistr}"
    logger.info "build all done."
  .catch (err) ->
    logger.debug err
