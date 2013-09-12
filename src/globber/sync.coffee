utils = require './utils'

module.exports = (paths, options = {}) ->
  if utils.isString(paths) then return globPath(paths, options)

  iterator = (accum, path) ->
    accum.concat (globPath path, options)

  paths.reduce iterator, []

globPath = (path, options) ->
  pattern = utils.getGlobPattern path, options
  paths = utils.glob.sync pattern, options

  if options.includeDirectories is false
    paths = paths.filter utils.isFileSync

  paths
