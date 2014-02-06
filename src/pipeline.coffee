events = require 'eventemitter2'

class PipeLine extends events.EventEmitter2
  constructor: (@task, @interval)->
    @items = []
    @working = false

  push: (items) ->
    @items = @items.concat items
    @work() unless @working

  work: =>
    return if @items.length < 1
    @working = true
    @task @items.shift(), (err, res) =>
      @emit 'pop', err, res
      if @items.length == 0
        @working = false
        @emit 'complete'
      else
        setTimeout @work, @interval

if __filename? and process.mainModule.filename is __filename
  console.log 'start!!'
  pipe1 = new PipeLine (item, next) ->
    console.log item
    next null, item*2
  , 1000

  pipe1.on 'pop', (err, res) ->
    console.log "pop #{res}"
    console.log pipe1.items

  pipe1.on 'complete', ->
    console.log 'finish!!'

  pipe1.push [1,2,3]

