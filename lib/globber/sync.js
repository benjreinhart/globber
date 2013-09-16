// Generated by CoffeeScript 2.0.0-beta7
void function () {
  var globPath, utils;
  utils = require('./utils');
  module.exports = function (paths, options) {
    var iterator;
    if (null == options)
      options = {};
    if (utils.isString(paths))
      return globPath(paths, options);
    iterator = function (accum, path) {
      return accum.concat(globPath(path, options));
    };
    return paths.reduce(iterator, []);
  };
  globPath = function (path, options) {
    var excludedPaths, paths, pattern;
    pattern = utils.getGlobPattern(path, options);
    paths = utils.glob.sync(pattern, options);
    if (excludedPaths = options.exclude)
      paths = utils.rejectPaths(paths, excludedPaths);
    if (options.includeDirectories === false)
      paths = paths.filter(utils.isFileSync);
    return paths;
  };
}.call(this);