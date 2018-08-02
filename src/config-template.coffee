
module.exports = ->

  template =
    base: 360
    source: 'REPLACE IT WITH YOUR dimens.xml PATH'
    targets: '%s'
    extract: 'REPLACE WITH THE DIRECTORY WHERE YOU NEED TO EXTRACT DP AND SP'
    output: 'REPLACE IT WITH YOUR OUTPUT PATH'
    dragon: 'REPLACE WITH THE DIRECTORY WHERE YOUR ANDROID MODULE PATH'

  JSON.stringify template, null, 2
