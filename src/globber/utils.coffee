fs = require 'fs'
Path = require 'path'

# https://github.com/isaacs/node-glob
exports.glob = require 'glob'

exports.getGlobPattern = (basePath, options) ->
  if options.absolute is true
    basePath = Path.resolve basePath

  if isGlob basePath
    return basePath

  {extension, recursive} = options

  fuzz = if recursive isnt false then '**/*' else '*'
  path = "#{basePath}/#{fuzz}"

  if extension?
    path += ".#{extension}"

  Path.normalize path

exports.isString = isString = (obj) ->
  ({}.toString.call obj) is '[object String]'

exports.isFile = (path, cb) ->
  fs.stat path, (err, stats) ->
    if err? then cb(err) else cb(null, stats.isFile())

exports.isFileSync = (path) ->
  (fs.statSync path).isFile()

exports.rejectPaths = (paths, excludedPaths) ->
  if isString excludedPaths
    return removePaths paths, excludedPaths

  iterator = (accum, pathToExclude) ->
    removePaths (accum ? paths), pathToExclude

  excludedPaths.reduce iterator, null

removePaths = (paths, pathToExclude) ->
  pathToExclude = Path.resolve(pathToExclude)
  pathToExclude = new RegExp "^#{pathToExclude.replace(/\//g, '\/')}.*"

  iterator = (accum, path) ->
    if Path.resolve(path).match(pathToExclude)?
      accum
    else
      accum.concat path

  paths.reduce iterator, []

isGlob = (str) ->
  (str.indexOf '*') isnt -1
