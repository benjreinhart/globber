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

exports.isFile = (path) ->
  (fs.statSync path).isFile()

exports.isString = (obj) ->
  ({}.toString.call obj) is '[object String]'

isGlob = (str) ->
  (str.indexOf '*') isnt -1
