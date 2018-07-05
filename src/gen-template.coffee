fs = require 'fs'
colors = require 'colors/safe'
path = require 'path'

TEMPLATE = () ->
  T =
    base: '360*640'
    source: '[PROJECT_LOCATION]/app/src/main/res/values/dimens.xml'
    targets: [
      '411*731'
      '360*720'
      '533*853'
    ]
    output: '[PROJECT_LOCATION]/app/src/main/res'

  template = JSON.stringify T, null, 2
  fs.writeFileSync path.join(process.cwd(), 'config.json'), template
  console.log "+ #{colors.yellow('[config.json]')} generate success in the current directory."

module.exports = TEMPLATE
