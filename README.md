# Globber

Wrapper around node-glob with a friendly DSL.

## Install

`npm install globber`

## Examples

```javascript
globber('projects/app/templates', {extension: 'mustache'}, function(err, paths){
  console.log(paths);
});
/*
  [
    'projects/app/templates/index.mustache',
    'projects/app/templates/partials',
    'projects/app/templates/partials/_form.mustache'
  ]
*/
```

```javascript
globber('projects/app/templates/**/*.mustache', function(err, paths){
  console.log(paths);
});
/*
  [
    'projects/app/templates/index.mustache',
    'projects/app/templates/partials',
    'projects/app/templates/partials/_form.mustache'
  ]
*/
```

```javascript
globber('projects/app/templates', {extension: 'mustache', includeDirectories: false}, function(err, paths){
  console.log(paths);
});
/*
  [
    'projects/app/templates/index.mustache',
    'projects/app/templates/partials/_form.mustache'
  ]
*/
```

```javascript
globber('projects/app/templates', {extension: 'mustache', recursive: false}, function(err, paths){
  console.log(paths);
});
/*
  [
    'projects/app/templates/index.mustache'
  ]
*/
```

```javascript
globber('projects/app/templates', {extension: 'mustache', absolute: true}, function(err, paths){
  console.log(paths);
});
/*
  [
    '/Users/breinhart/projects/app/templates/index.mustache',
    '/Users/breinhart/projects/app/templates/partials',
    '/Users/breinhart/projects/app/templates/partials/_form.mustache'
  ]
*/
```

## API

##### globber(path[, options], callback)

`path` can be base path to begin searching from or a glob string.

`options` can be the following

* `absolute` {Boolean} - If `true`, all paths returned will be absolute, regardless of the initial path
* `extension` {String} - Only search for files with extension `extension`
* `recursive` {Boolean} - If `false`, will only search for files one level deep
* `includeDirectories` {Boolean} - if `false`, the resulting `paths` array will only include paths to files, not paths to directories

Any options passed to globber not listed above will be passed to [node-glob](https://github.com/isaacs/node-glob).

`callback` function takes `err` and `paths` arguments.

##### globber.sync(path[, options])

Synchronous version of `globber`.

##### globber.glob

A direct reference to [node-glob](https://github.com/isaacs/node-glob). This is mainly exposed for stubbing purposes in the globber test suite and should not be used. If you find yourself using this directly, you should probably just be using the node-glob library and not this one.

## License

(The MIT License)

Copyright (c) 2013 Ben Reinhart

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
