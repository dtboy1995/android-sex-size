fs = require 'fs'
file = "#{__dirname}/../bin/cli.js"
clistr = fs.readFileSync file, 'utf-8'
fs.writeFileSync file, "#!/usr/bin/env node\n#{clistr}"
