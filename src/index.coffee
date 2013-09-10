fs = require 'fs'
glob = require 'glob'
Path = require 'path'

supportedOptions = [
  'absolute'
  'extension'
  'recursive'
  'includeDirectories'
]

module.exports = globber = (basePath, options, cb) ->
  if 'function' is typeof options then cb = options; options = {}
  [options, globOptions] = partitionOptions options

  if options.absolute is true
    basePath = Path.resolve basePath

  globber.glob (getGlobPath basePath, options), globOptions, (err, paths) ->
    if err? then return cb(err)

    if options.includeDirectories is false
      paths = paths.filter isFile

    cb null, paths
  undefined

# Expose glob (https://github.com/isaacs/node-glob)
globber.glob = glob

globber.sync = (basePath, options = {}) ->
  [options, globOptions] = partitionOptions options

  if options.absolute is true
    basePath = Path.resolve basePath

  paths = globber.glob.sync (getGlobPath basePath, options), globOptions

  if options.includeDirectories is false
    paths = paths.filter isFile

  paths

getGlobPath = (basePath, options) ->
  if isGlob(basePath) then return basePath

  {extension, recursive} = options

  fuzz = if recursive isnt false then '**/*' else '*'
  path = "#{basePath}/#{fuzz}"

  if extension?
    path += ".#{extension}"

  Path.normalize path

partitionOptions = (options) ->
  [supported, other] = (result = [{}, {}])

  for own key, value of options
    do (key, value) ->
      (if key in supportedOptions then supported else other)[key] = value

  [supported, other]

isGlob = (str) ->
  (str.indexOf '*') isnt -1

isFile = (path) ->
  (fs.statSync path).isFile()
