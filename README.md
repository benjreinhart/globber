# Globber

Wrapper around [node-glob](https://github.com/isaacs/node-glob) with a friendly DSL.

## Install

`npm install globber`

## Examples

Given the following paths exist:

* /Users/ben/projects/contacts/templates/index.mustache
* /Users/ben/projects/contacts/templates/show.mustache
* /Users/ben/projects/todos/templates/index.mustache
* /Users/ben/projects/todos/templates/info.txt
* /Users/ben/projects/todos/templates/partials/_form.mustache

And the current working directory is /Users/ben


```javascript
globber('projects/todos/templates', {extension: 'mustache'}, function(err, paths){
  console.log(paths);
});
/*
  [
    'projects/todos/templates/index.mustache',
    'projects/todos/templates/partials/_form.mustache'
  ]
*/
```

```javascript
var basePaths = ['projects/todos/templates', 'projects/contacts/templates'];
globber(basePaths, {extension: 'mustache'}, function(err, paths){
  console.log(paths);
});
/*
  [
    'projects/contacts/templates/index.mustache',
    'projects/contacts/templates/show.mustache',
    'projects/todos/templates/partials/_form.mustache',
    'projects/todos/templates/index.mustache'
  ]
*/
```

```javascript
globber('projects/todos/templates/**/*.mustache' function(err, paths){
  console.log(paths);
});
/*
  [
    'projects/todos/templates/index.mustache',
    'projects/todos/templates/partials/_form.mustache'
  ]
*/
```

```javascript
globber('projects/todos/templates', function(err, paths){
  console.log(paths);
});
/*
  [
    'projects/todos/templates/index.mustache',
    'projects/todos/templates/info.txt',
    'projects/todos/templates/partials',
    'projects/todos/templates/partials/_form.mustache'
  ]
*/
```

```javascript
globber('projects/todos/templates', {includeDirectories: false}, function(err, paths){
  console.log(paths);
});
/*
  [
    'projects/todos/templates/index.mustache',
    'projects/todos/templates/info.txt'
    'projects/todos/templates/partials/_form.mustache'
  ]
*/
```

```javascript
globber('projects/todos/templates', {extension: 'mustache', recursive: false}, function(err, paths){
  console.log(paths);
});
/*
  [
    'projects/todos/templates/index.mustache'
  ]
*/
```

```javascript
globber('projects/todos/templates', {extension: 'mustache', absolute: true}, function(err, paths){
  console.log(paths);
});
/*
  [
    '/Users/ben/projects/todos/templates/index.mustache',
    '/Users/ben/projects/todos/templates/partials/_form.mustache'
  ]
*/
```

## API

##### globber(path[, options], callback)

`path` can be a base path to begin searching from or a glob string or an array of base paths and/or glob strings.

`options` can be the following

* `absolute` {Boolean} - If `true`, all paths returned will be absolute, regardless of the initial path
* `extension` {String} - Only search for files with extension `extension`
* `recursive` {Boolean} - If `false`, will only search for files one level deep
* `includeDirectories` {Boolean} - if `false`, the resulting `paths` array will only include paths to files, not paths to directories

Any options passed to globber not listed above will be passed to [node-glob](https://github.com/isaacs/node-glob).

`callback` function takes `err` and `paths` arguments.

##### globber.sync(path[, options])

Synchronous version of `globber`.

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
