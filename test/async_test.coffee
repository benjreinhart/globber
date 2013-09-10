utils = require '../lib/globber/utils'
sinon = require 'sinon'
globber = require '../'
{expect} = require 'chai'

describe 'globber/async', ->
  beforeEach ->
    sinon.stub(process, 'cwd').returns '/absolute'
    sinon.stub utils, 'glob', (_, __, cb) ->
      process.nextTick cb.bind null, null, [
        'path/to/something/else'
        'path/to/something/else/file.txt'
      ]

    @glob = utils.glob
    sinon.stub utils, 'isFile', (path) -> path isnt 'path/to/something/else'

  afterEach ->
    process.cwd.restore()
    utils.glob.restore()
    utils.isFile.restore()

  it 'recursively searches a starting path and returns all paths found', (done) ->
    globber 'path/to/something', {extension: 'txt'}, (err, paths) =>
      expect(@glob.calledOnce).to.be.true
      expect(@glob.firstCall.args[0]).to.eql 'path/to/something/**/*.txt'
      expect(@glob.firstCall.args[1]).to.be.instanceof Object
      expect(@glob.firstCall.args[2]).to.be.instanceof Function
      expect(paths).to.eql [
        'path/to/something/else'
        'path/to/something/else/file.txt'
      ]
      done()

  it 'only searches one level deep if recursive option is false', (done) ->
    globber 'path/to/something', {extension: 'txt', recursive: false}, (err, paths) =>
      expect(@glob.calledOnce).to.be.true
      expect(@glob.firstCall.args[0]).to.eql 'path/to/something/*.txt'
      expect(@glob.firstCall.args[1]).to.be.instanceof Object
      done()

  it 'does not include directory paths if includeDirectories option is false', (done) ->
    globber 'path/to/something', {extension: 'txt', includeDirectories: false}, (err, paths) =>
      expect(@glob.calledOnce).to.be.true
      expect(@glob.firstCall.args[0]).to.eql 'path/to/something/**/*.txt'
      expect(@glob.firstCall.args[1]).to.be.instanceof Object
      expect(@glob.firstCall.args[2]).to.be.instanceof Function
      expect(paths).to.eql ['path/to/something/else/file.txt']
      done()

  it 'returns absolute paths if absolute option is true', (done) ->
    globber 'path/to/something', {extension: 'txt', absolute: true}, (err, paths) =>
      expect(@glob.calledOnce).to.be.true
      expect(@glob.firstCall.args[0]).to.eql '/absolute/path/to/something/**/*.txt'
      expect(@glob.firstCall.args[1]).to.be.instanceof Object
      expect(@glob.firstCall.args[2]).to.be.instanceof Function
      done()

  it 'passes all other options to glob.sync', (done) ->
    options =
      extension: 'txt'
      absolute: true
      includeDirectories: false
      recursive: false
      cwd: 'op'
      root: 'op2'
      cache: 'op3'

    globber 'path/to/something', options, (err, paths) =>
      expect(@glob.calledOnce).to.be.true
      expect(@glob.firstCall.args[1]).to.include.keys 'cwd', 'root', 'cache'
      done()

  it 'accepts a glob string as the first argument', (done) ->
    globber 'path/to/something/**/*.csv', (err, paths) =>
      expect(@glob.calledOnce).to.be.true
      expect(@glob.firstCall.args[0]).to.eql 'path/to/something/**/*.csv'
      expect(@glob.firstCall.args[1]).to.be.instanceof Object
      expect(@glob.firstCall.args[2]).to.be.instanceof Function
      done()

  it 'accepts an array of paths/patterns as first argument', (done) ->
    globber ['path/to/something', 'path/to/another/thing'], {extension: 'txt'}, (err, paths) =>
      expect(@glob.calledTwice)
      expect(@glob.firstCall.args[0]).to.eql 'path/to/something/**/*.txt'
      expect(@glob.secondCall.args[0]).to.eql 'path/to/another/thing/**/*.txt'

      # Actual results don't matter (since glob is stubbed to always return these two paths),
      # but it is important to assert that the result contains a concatenated list of the results
      # of all calls to glob.sync
      expect(paths).to.eql [
        'path/to/something/else'
        'path/to/something/else/file.txt'
        'path/to/something/else'
        'path/to/something/else/file.txt'
      ]

      done()