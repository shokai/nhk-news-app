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

  join: (pipe) ->
    @on 'pop', (err, res) ->
      return if err
      pipe.push res

if __filename? and process.mainModule.filename is __filename

  pipe1 = new PipeLine (item, next) ->
    next null, item*2
  , 1000

  pipe2 = new PipeLine (item, next) ->
    next null, "aaaa"+item

  pipe1.join pipe2

  pipe1.on 'pop', (err, res) ->
    console.log pipe1.items
    if res % 3 == 0
      pipe1.push 8

  pipe2.on 'pop', (err, res) ->
    console.log "pop #{res}"

  pipe1.on 'complete', ->
    console.log 'finish!!'

  pipe1.push [1,2,3,4,5,6]

