Path = require 'path'
utils = require './utils'

module.exports = (paths, options = {}) ->
  if utils.isString(paths) then return getPaths(paths, options)

  iterator = (accum, path) ->
    accum.concat (getPaths path, options)

  paths.reduce iterator, []

getPaths = (path, options) ->
  paths = findAll(path, options)

  if excludedPaths = options.exclude
    paths = utils.rejectPaths paths, excludedPaths

  if options.includeDirectories is false
    paths = paths.filter utils.isFileSync

  paths

findAll = (path, options) ->
  if options.absolute is true
    path = Path.resolve path

  if utils.isFileSync path
    [path]
  else
    pattern = utils.getGlobPattern path, options
    utils.glob.sync pattern, options
