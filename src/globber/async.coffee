utils = require './utils'
async = require 'async'

module.exports = (paths, options, callback) ->
  if 'function' is typeof options then callback = options; options = {}
  if utils.isString(paths) then return globPath(paths, options, callback)

  iterator = (accum, path, cb) ->
    globPath path, options, (err, paths) ->
      if err? then return cb(err)
      cb null, accum.concat paths

  async.reduce paths, [], iterator, callback
  undefined

globPath = (path, options, cb) ->
  pattern = utils.getGlobPattern path, options
  utils.glob pattern, options, (err, paths) ->
    if err? then return cb(err)

    if options.includeDirectories is false
      paths = paths.filter utils.isFile

    cb null, paths
  undefined
