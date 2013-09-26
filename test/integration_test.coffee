run = (require 'child_process').execFile

describe 'globber', ->
  it 'basic recursive search returns all file and directory paths infinitely deep', (done) ->
    run 'test/tests/basic_recursive_search', done

  it 'basic non recursive search returns only files and directories inside the path argument', (done) ->
    run 'test/tests/basic_non_recursive_search', done

  it 'does not include directory paths if includeDirectories option is false', (done) ->
    run 'test/tests/include_directories_option', done

  it 'returns absolute paths if absolute option is true', (done) ->
    run 'test/tests/absolute_path_option', done

  it 'only returns files with extension equal to the extension provided', (done) ->
    run 'test/tests/extension_option', done

  it 'accepts a glob string as the first argument', (done) ->
    run 'test/tests/glob_string_as_path_argument', done

  it 'accepts an array of paths/patterns as first argument', (done) ->
    run 'test/tests/array_of_paths_as_path_argument', done

  it 'excludes a path using the exclude option', (done) ->
    run 'test/tests/exclude_path', done

  it 'excludes multiple paths if the exclude option is an array of paths', (done) ->
    run 'test/tests/exclude_multiple_paths', done

  it 'properly works with a combination of options', (done) ->
    run 'test/tests/combination', done

  it 'returns the given path in an array if the given path is a file', (done) ->
    run 'test/tests/file_path', done

  it 'resolves paths to files as absolute paths', (done) ->
    run 'test/tests/file_path_absolute', done
