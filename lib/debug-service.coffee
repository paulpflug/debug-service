module.exports = new class DebugService
  config:
    debug:
      type: "integer"
      default: 0
      minimum: 0
  disposables: null
  activate: ->
    {CompositeDisposable} = require 'atom'
    @nsps = {}
    @nullFunc = -> return -> return null
    @getRandomColor = ->
      letters = '0123456789ABCDEF'.split('')
      color = '#'
      for i in [0..5]
        color += letters[Math.floor(Math.random() * 16)]
      return color
    @disposables = new CompositeDisposable
    @debug = @provideDebug()(pkg: "debug-service", nsp:"")
  provideDebug: =>
    return ({pkg,nsp}) =>
      return @nullFunc unless atom.inDevMode()
      debugLevel = null
      try
        updateDebugLevel = =>
          old = debugLevel
          debugLevel = atom.config.get("#{pkg}.debug")
          if old?
            @debug "updating debugLevel for #{pkg} from #{old} to #{debugLevel}", 2
        @disposables.add atom.config.observe("#{pkg}.debug",updateDebugLevel)
      log = (nsp) =>
        nspString = "#{pkg}"
        nspString += ".#{nsp}" if nsp
        @nsps[nspString] ?= @getRandomColor()
        nspColor = @nsps[nspString]
        return (string,lvl) ->
          if not lvl? or not debugLevel? or debugLevel >= lvl
            console.log "%c#{nspString}:","color:#{nspColor}", "#{string}"
      return log(nsp) if nsp?
      return log
  consumeAutoreload: (reloader) =>
    reloader(pkg:"debug-service")
    @debug "autoreload service consumed", 2
