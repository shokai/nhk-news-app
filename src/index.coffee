_ = require 'lodash'
path = require 'path'
events = require 'eventemitter2'
async = require 'async'
gui = require 'nw.gui'

pkg_info = require path.resolve 'package.json'

$ ->
  gui.Window.get().title += " v#{pkg_info.version}"

class News extends events.EventEmitter2
  constructor: ->
    @news = []
    @nhk = new NHK

  run: (interval=300000) ->
    setInterval =>
      @fetch()
    , interval
    @fetch()

  fetch: ->
    print 'fetch'
    @nhk.getNews (err, news) =>
      if err
        @emit 'error', err
        return
      news = _.reject news, (i) -> _.include @news, i
      async.map news, @nhk.hasVideo, (err, results) =>
        for res, index in results by -1
          unless res
            print "#{news[index].url} no video"
            news.splice index, 1
        @news.concat news
        if news.length > 0
          @emit 'fetch', news
        else
          @emit 'error', '動画付きニュースがありません'

class Player
  constructor: (@iframe=$('iframe'))->
    @urls = []
    @seek = 0
    @interval = 90000
    @iframe?.on 'load', =>
      ## ビデオを自動再生
      setTimeout =>
        @iframe.contents().find('#news_image').click()
        setTimeout =>
          @iframe.contents().find('object').css({width:640, height: 360})
          @iframe.contents().find('#news_image_div2').css({height: 360})
        , 500
      , 1000

    setInterval =>
      @load @urls[@seek] if @urls.length > @seek
    , 100

    win = gui.Window.get()
    last_image = null
    setInterval =>
      win.capturePage (image) =>
        if last_image is image  ## 動画が停止していたら、次のニュースへ移動
          @next()
        last_image = image
      , 'png'
    , 5000


  load: (url)->
    return unless @iframe?
    return if @iframe.attr('src') is url
    print "load #{url}"
    @iframe.attr src: url

  next: ->
    @seek += 1
    @seek = 0 if @seek >= @urls.length or @seek < 0

  add: (url) ->
    print "add #{url}"
    unless _.include @urls, url
      @urls.unshift url
      @seek = 0


window.news = new News

$ ->
  window.player = new Player
  news.run()
  news.on 'fetch', (data) ->
    $("#msgbox").hide()
    for i in data
      player.add i.url
  news.on 'error', (err) ->
    print err


print = (msg) ->
  console.log msg
  msgbox = $("#msgbox")
  if typeof msg is 'string'
    msgbox.text(msg)
  else
    msgbox.html(msg)
  # msgbox.show()

