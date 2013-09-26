Path = require 'path'
utils = require './utils'
async = require 'async'

module.exports = (paths, options, callback) ->
  if 'function' is typeof options then callback = options; options = {}
  if utils.isString(paths) then return getPaths(paths, options, callback)

  iterator = (accum, path, cb) ->
    getPaths path, options, (err, paths) ->
      if err? then return cb(err)
      cb null, accum.concat paths

  async.reduce paths, [], iterator, callback
  undefined

getPaths = (path, options, cb) ->
  findAll path, options, (err, paths) ->
    if err? then return cb(err)

    tasks = buildTasks paths, options

    if !tasks.length
      cb null, paths
    else
      async.waterfall tasks, (err, paths) ->
        if err? then cb(err) else cb(null, paths)
  undefined

findAll = (path, options, cb) ->
  if options.absolute is true
    path = Path.resolve path

  utils.isFile path, (pathIsFile) ->
    if pathIsFile
      cb null, [path]
    else
      pattern = utils.getGlobPattern path, options
      utils.glob pattern, options, cb

buildTasks = (paths, options) ->
  tasks = []

  if (excludedPaths = options.exclude)?
    tasks.push (cb) ->
      cb null, (utils.rejectPaths paths, excludedPaths)

  if options.includeDirectories is false
    removeDirectories = (paths, cb) ->
      async.filter paths, utils.isFile, (files) -> cb null, files

    if !tasks.length
      removeDirectories = removeDirectories.bind null, paths

    tasks.push removeDirectories

  tasks
