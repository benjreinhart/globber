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

    tasks = buildTasks paths, options

    if !tasks.length
      cb null, paths
    else
      async.waterfall tasks, (err, paths) ->
        if err? then cb(err) else cb(null, paths)
  undefined

buildTasks = (paths, options) ->
  tasks = []

  if (excludedPaths = options.exclude)?
    tasks.push (cb) ->
      cb null, (utils.rejectPaths paths, excludedPaths)

  if options.includeDirectories is false
    removeDirectories = (paths, cb) ->
      async.filter paths, isFile, (files) -> cb null, files

    if !tasks.length
      removeDirectories = removeDirectories.bind null, paths

    tasks.push removeDirectories

  tasks

# Wrap utils.isFile to be consistent with what the async.filter iterator
# callback expects (it expects one argument, true or false, no error argument).
isFile = (path, cb) ->
  utils.isFile path, (err, file) ->
    if err? then throw err
    cb file
