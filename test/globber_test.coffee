fs = require 'fs'
sinon = require 'sinon'
globber = require '../'
{expect} = require 'chai'

describe 'globber', ->
  beforeEach ->
    globResults = ['path/to/something/else', 'path/to/something/else/file.txt']

    @glob = glob = (path, opts, cb) ->
      process.nextTick cb.bind null, null, globResults
    @glob = sinon.stub(this, 'glob', glob)

    @glob.sync = sinon.stub()
    @glob.sync.returns globResults
    sinon.stub(globber, 'glob', @glob)

    statSync = (path) ->
      isFile: -> path isnt 'path/to/something/else'

    sinon.stub(fs, 'statSync', statSync)

  afterEach ->
    globber.glob.restore()
    fs.statSync.restore()
    process.cwd.restore?()

  it 'recursively searches a starting path and returns all paths found', (done) ->
    globber 'path/to/something', {extension: 'txt'}, (err, paths) =>
      expect(@glob.calledOnce).to.be.true
      expect(@glob.firstCall.args[0]).to.eql 'path/to/something/**/*.txt'
      expect(@glob.firstCall.args[1]).to.eql {}
      expect(@glob.firstCall.args[2]).to.be.instanceof Function
      expect(paths).to.eql [
        'path/to/something/else', 'path/to/something/else/file.txt'
      ]
      done()

  it 'only searches one level deep if recursive option is false', (done) ->
    globber 'path/to/something', {extension: 'txt', recursive: false}, (err, paths) =>
      expect(@glob.calledOnce).to.be.true
      expect(@glob.firstCall.args[0]).to.eql 'path/to/something/*.txt'
      done()

  it 'does not include directory paths if includeDirectories option is false', (done) ->
    globber 'path/to/something', {extension: 'txt', includeDirectories: false}, (err, paths) =>
      expect(@glob.calledOnce).to.be.true
      expect(@glob.firstCall.args[0]).to.eql 'path/to/something/**/*.txt'
      expect(@glob.firstCall.args[1]).to.eql {}
      expect(@glob.firstCall.args[2]).to.be.instanceof Function
      expect(paths).to.eql ['path/to/something/else/file.txt']
      done()

  it 'returns absolute paths if absolute option is true', (done) ->
    sinon.stub(process, 'cwd').returns '/absolute'
    globber 'path/to/something', {extension: 'txt', absolute: true}, (err, paths) =>
      expect(@glob.calledOnce).to.be.true
      expect(@glob.firstCall.args[0]).to.eql '/absolute/path/to/something/**/*.txt'
      expect(@glob.firstCall.args[1]).to.eql {}
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
      expect(@glob.firstCall.args[1]).to.eql
        cwd: 'op'
        root: 'op2'
        cache: 'op3'

      done()

  it 'accepts a glob string as the first argument', (done) ->
    globber 'path/to/something/**/*.txt', (err, paths) =>
      expect(@glob.calledOnce).to.be.true
      expect(@glob.firstCall.args[0]).to.eql 'path/to/something/**/*.txt'
      expect(@glob.firstCall.args[1]).to.eql {}
      expect(@glob.firstCall.args[2]).to.be.instanceof Function
      done()


  describe 'sync', ->
    it 'recursively searches a starting path and returns all paths found', ->
      paths = globber.sync 'path/to/something', {extension: 'txt'}

      expect(@glob.sync.calledOnce).to.be.true
      expect(@glob.sync.firstCall.args).to.eql ['path/to/something/**/*.txt', {}]
      expect(paths).to.eql [
        'path/to/something/else'
        'path/to/something/else/file.txt'
      ]

    it 'only searches one level deep if recursive option is false', ->
      globber.sync 'path/to/something', {extension: 'txt', recursive: false}
      expect(@glob.sync.calledOnce).to.be.true
      expect(@glob.sync.firstCall.args).to.eql ['path/to/something/*.txt', {}]

    it 'does not include directory paths if includeDirectories option is false', ->
      @glob.sync.returns ['path/to/something/else', 'path/to/something/else/file.txt']
      paths = globber.sync 'path/to/something', {extension: 'txt', includeDirectories: false}

      expect(@glob.sync.calledOnce).to.be.true
      expect(@glob.sync.firstCall.args).to.eql ['path/to/something/**/*.txt', {}]
      expect(paths).to.eql ['path/to/something/else/file.txt']

    it 'returns absolute paths if absolute option is true', ->
      sinon.stub(process, 'cwd').returns '/absolute'
      paths = globber.sync 'path/to/something', {extension: 'txt', absolute: true}

      expect(@glob.sync.calledOnce).to.be.true
      expect(@glob.sync.firstCall.args).to.eql ['/absolute/path/to/something/**/*.txt', {}]

    it 'passes all other options to glob.sync', ->
      @glob.sync.returns []
      globber.sync 'path/to/something',
        extension: 'txt'
        absolute: true
        includeDirectories: false
        recursive: false
        cwd: 'op'
        root: 'op2'
        cache: 'op3'

      expect(@glob.sync.calledOnce).to.be.true
      expect(@glob.sync.firstCall.args[1]).to.eql
        cwd: 'op'
        root: 'op2'
        cache: 'op3'

    it 'accepts a glob string as the first argument', ->
      paths = globber.sync 'path/to/something/**/*.txt'
      expect(@glob.sync.calledOnce).to.be.true
      expect(@glob.sync.firstCall.args).to.eql ['path/to/something/**/*.txt', {}]
