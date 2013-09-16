# Globber

Wrapper around [node-glob](https://github.com/isaacs/node-glob) with a friendly DSL.

## Install

`npm install globber`

## Basic Example

For a more elaborate set of examples, check out [the examples below](#more-examples) and the [tests](https://github.com/benjreinhart/globber/tree/master/test/tests).

```javascript
globber('project/templates', function(err, paths){
  console.log(paths);
});
/*
  [
    'project/templates/sessions',
    'project/templates/sessions/info.txt',
    'project/templates/sessions/login.mustache',
    'project/templates/users',
    'project/templates/users/index.mustache',
    'project/templates/users/info.txt',
    'project/templates/users/show.mustache'
  ]
*/
```

## API

##### globber(path[, options], callback)

`path` can be a base path to begin searching from or a glob string or an array of base paths and/or glob strings.

`options` can be the following

* `absolute` {Boolean} - If `true`, all paths returned will be absolute, regardless of the initial path
* `extension` {String} - Only search for files with extension `extension`
* `exclude` {String|Array} - Either a path or array of paths to be excluded from the result set
* `recursive` {Boolean} - If `false`, will only search for files one level deep
* `includeDirectories` {Boolean} - if `false`, the resulting `paths` array will only include paths to files, not paths to directories

Any options passed to globber not listed above will be passed to [node-glob](https://github.com/isaacs/node-glob).

`callback` function takes `err` and `paths` arguments.

##### globber.sync(path[, options])

Synchronous version of `globber`.

## More Examples

Give the current directory structure:

```
/Users/ben
  └ project
      └ templates
          └ sessions
              └ info.txt
                login.mustache
            users
              └ index.mustache
                info.txt
                show.mustache
```

and a current working directory of `/Users/ben`:

<hr />

Perform a recursive search for all files in the `project/templates` directory relative to the current working directory:

```javascript
globber('project/templates', function(err, paths){
  console.log(paths);
});
/*
  [
    'project/templates/sessions',
    'project/templates/sessions/info.txt',
    'project/templates/sessions/login.mustache',
    'project/templates/users',
    'project/templates/users/index.mustache',
    'project/templates/users/info.txt',
    'project/templates/users/show.mustache'
  ]
*/
```

<hr />

Do the same as the above but exclude certain paths and return all paths as absolute paths:

```javascript
var pathsToExclude = ['project/templates/users/info.txt', 'project/templates/sessions/info.txt'];
globber('project/templates', {absolute: true, exclude: pathsToExclude}, function(err, paths){
  console.log(paths);
});
/*
  [
    '/Users/ben/project/templates/sessions',
    '/Users/ben/project/templates/sessions/login.mustache',
    '/Users/ben/project/templates/users',
    '/Users/ben/project/templates/users/index.mustache',
    '/Users/ben/project/templates/users/show.mustache'
  ]
*/
```

<hr />

Scope the recursive search only to files with a "mustache" extension in the `project/templates` directory relative to the current working directory:

```javascript
globber('project/templates', {extension: 'mustache'}, function(err, paths){
  console.log(paths);
});
/*
  [
    'project/templates/sessions',
    'project/templates/sessions/login.mustache',
    'project/templates/users',
    'project/templates/users/index.mustache',
    'project/templates/users/show.mustache'
  ]
*/
```

<hr />

Search multiple directories:

```javascript
globber(['project/templates/sessions', 'project/templates/users'], function(err, paths){
  console.log(paths);
});
/*
  [
    'project/templates/sessions',
    'project/templates/sessions/info.txt',
    'project/templates/sessions/login.mustache',
    'project/templates/users',
    'project/templates/users/index.mustache',
    'project/templates/users/info.txt',
    'project/templates/users/show.mustache'
  ]
*/
```

<hr />

Only search in the directory provided, not in any sub directories:

```javascript
globber('project/templates', {recursive: false}, function(err, paths){
  console.log(paths);
});
/*
  [
    'project/templates/sessions',
    'project/templates/users'
  ]
*/
```

<hr />

Only return paths that are files (will remove paths of directories from the result set):

```javascript
globber('project/templates', {includeDirectories: false}, function(err, paths){
  console.log(paths);
});
/*
  [
    'project/templates/sessions/info.txt',
    'project/templates/sessions/login.mustache',
    'project/templates/users/index.mustache',
    'project/templates/users/info.txt',
    'project/templates/users/show.mustache'
  ]
*/
```

<hr />

Pass a glob string directly:

```javascript
globber('project/templates/**/*.mustache', function(err, paths){
  console.log(paths);
});
/*
  [
    'project/templates/sessions',
    'project/templates/sessions/login.mustache',
    'project/templates/users',
    'project/templates/users/index.mustache',
    'project/templates/users/show.mustache'
  ]
*/
```

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
