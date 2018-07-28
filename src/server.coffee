_           =   require 'lodash'
path        =   require 'path'
colors      =   require 'colors/safe'
express     =   require 'express'
bodyParser  =   require 'body-parser'
favicon     =   require 'serve-favicon'
app         =   express()
template    =   require './config-template'
extracter   =   require './extracter'
measurer    =   require './measurer'

SERVER_PORT     =   8888
SERVER_ADDR     =   "http://localhost:#{SERVER_PORT}"
DEFAULT_TARGETS =   require './common'

app.use favicon(path.join(__dirname, '..' ,'art', 'favicon.ico'))
app.use bodyParser.urlencoded( extended: true )
app.use bodyParser.json()
app.use '/', express.static(path.join(__dirname, '..', 'art'))

app.get '/config', (req, res) ->
  res.send template().replace('%s', DEFAULT_TARGETS)

app.post '/measure', (req, res, next) ->
  measurer req.body
    .then ->
      res.sendStatus 204
    .catch next

app.post '/extract', (req, res, next) ->
  extracter req.body
    .then ->
      res.sendStatus 204
    .catch next

app.use (req, res, next) ->
  err = new Error 'Not Found'
  next err

app.use (err, req, res, next) ->
  console.log "#{colors.red '[error]'}#{err}"
  res.send err: err

handler = () ->
  app.listen SERVER_PORT, (err) ->
    unless err
      console.log "#{colors.green '[success]'} use your browser to access the #{colors.yellow SERVER_ADDR}"
    else
      throw err

module.exports = handler
