utils = require '../lib/globber/utils'
sinon = require 'sinon'
globber = require '../'
{expect} = require 'chai'

describe 'globber/sync', ->
  beforeEach ->
    sinon.stub(process, 'cwd').returns '/absolute'
    sinon.stub(utils.glob, 'sync').returns [
      'path/to/something/else'
      'path/to/something/else/file.txt'
    ]
    @globSync = utils.glob.sync

    sinon.stub utils, 'isFile', (path) -> path isnt 'path/to/something/else'

  afterEach ->
    process.cwd.restore()
    utils.glob.sync.restore()
    utils.isFile.restore()

  it 'recursively searches a starting path and returns all paths found', ->
    paths = globber.sync 'path/to/something', {extension: 'txt'}

    expect(@globSync.calledOnce).to.be.true
    expect(@globSync.firstCall.args[0]).to.eql 'path/to/something/**/*.txt'
    expect(@globSync.firstCall.args[1]).to.be.instanceof Object
    expect(paths).to.eql [
      'path/to/something/else'
      'path/to/something/else/file.txt'
    ]

  it 'only searches one level deep if recursive option is false', ->
    paths = globber.sync 'path/to/something', {extension: 'txt', recursive: false}

    expect(@globSync.calledOnce).to.be.true
    expect(@globSync.firstCall.args[0]).to.eql 'path/to/something/*.txt'
    expect(@globSync.firstCall.args[1]).to.be.instanceof Object

  it 'does not include directory paths if includeDirectories option is false', ->
    paths = globber.sync 'path/to/something', {extension: 'txt', includeDirectories: false}

    expect(@globSync.calledOnce).to.be.true
    expect(@globSync.firstCall.args[0]).to.eql 'path/to/something/**/*.txt'
    expect(@globSync.firstCall.args[1]).to.be.instanceof Object
    expect(paths).to.eql ['path/to/something/else/file.txt']

  it 'returns absolute paths if absolute option is true', ->
    paths = globber.sync 'path/to/something', {extension: 'txt', absolute: true}

    expect(@globSync.calledOnce).to.be.true
    expect(@globSync.firstCall.args[0]).to.eql '/absolute/path/to/something/**/*.txt'
    expect(@globSync.firstCall.args[1]).to.be.instanceof Object

  it 'passes all options to glob.sync', ->
    globber.sync 'path/to/something',
      extension: 'txt'
      absolute: true
      includeDirectories: false
      recursive: false
      cwd: 'op'
      root: 'op2'
      cache: 'op3'

    expect(@globSync.calledOnce).to.be.true

    optionsArg = @globSync.firstCall.args[1]
    expect(optionsArg).to.include.keys 'cwd', 'root', 'cache'

  it 'accepts a glob string as the first argument', ->
    paths = globber.sync 'path/to/something/**/*.csv'
    expect(@globSync.calledOnce).to.be.true
    expect(@globSync.firstCall.args[0]).to.eql 'path/to/something/**/*.csv'
    expect(@globSync.firstCall.args[1]).to.be.instanceof Object

  it 'accepts an array of paths/patterns as first argument', ->
    paths = globber.sync ['path/to/something', 'path/to/another/thing'], {extension: 'txt'}

    expect(@globSync.calledTwice)
    expect(@globSync.firstCall.args[0]).to.eql 'path/to/something/**/*.txt'
    expect(@globSync.secondCall.args[0]).to.eql 'path/to/another/thing/**/*.txt'

    # Actual results don't matter (since glob is stubbed to always return these two paths),
    # but it is important to assert that the result contains a concatenated list of the results
    # of all calls to glob.sync
    expect(paths).to.eql [
      'path/to/something/else'
      'path/to/something/else/file.txt'
      'path/to/something/else'
      'path/to/something/else/file.txt'
    ]
