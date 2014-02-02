require './nhk'

nhk = new NHK
urls = []

$ ->
  nhk.getNews (err, news) ->
    cid = setInterval ->
      load news.shift().url
      clearInterval cid if news.length < 1
    , 10000

  $('iframe').on 'load', =>
    ## ビデオを自動再生
    setTimeout =>
      $('iframe').contents().find('#news_image').click()
    , 1000

    setTimeout ->
      next()
    , 90000  ## 1.5分で次のニュースへ移動

load = (url) ->
  $("#msgbox").hide()
  $('iframe').attr src: url

next = ->
