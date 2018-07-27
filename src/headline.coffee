fs      =   require 'fs'
file    =   "#{__dirname}/../bin/ruler.js"
clistr  =   fs.readFileSync file, 'utf-8'

fs.writeFileSync file, "#!/usr/bin/env node\n#{clistr}"
