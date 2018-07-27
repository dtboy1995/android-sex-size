fs        =   require 'fs'
colors    =   require 'colors/safe'
path      =   require 'path'

module.exports = ->

  output = path.join process.cwd(), 'config.json'
  template =
    base: 360
    source: 'REPLACE IT WITH YOUR dimens.xml PATH'
    targets: [ 384 ,392, 400, 410, 411, 480, 533, 592, 600, 640, 662, 720, 768, 800, 811, 820 ]
    output: 'REPLACE IT WITH YOUR OUTPUT PATH'
    extract: 'REPLACE WITH THE DIRECTORY WHERE YOU NEED TO EXTRACT DP AND SP'
  fs.writeFileSync output, JSON.stringify(template, null, 2)

  console.log "#{colors.cyan '+'} [config.json] #{colors.yellow 'generated.'}"
