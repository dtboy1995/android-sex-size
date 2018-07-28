module.exports = ->

  template =
    base: 360
    source: 'REPLACE IT WITH YOUR dimens.xml PATH'
    targets: '%s'
    output: 'REPLACE IT WITH YOUR OUTPUT PATH'
    extract: 'REPLACE WITH THE DIRECTORY WHERE YOU NEED TO EXTRACT DP AND SP'

  JSON.stringify template, null, 2
