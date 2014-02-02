request    = require 'request'
FeedParser = require 'feedparser'
events     = require 'eventemitter2'

class NHK extends events.EventEmitter2
  getNews: (callback) ->
    throw new Error('argument error') if typeof callback isnt 'function'
    url = 'http://www3.nhk.or.jp/rss/news/cat0.xml'
    news = []
    feed = request(url).pipe(new FeedParser)
    feed .on 'error', (err) ->
      callback err
    feed.on 'data', (chunk) ->
      news.push {url: chunk.link, title: chunk.title}
    feed.on 'end', ->
      callback null, news

if exports?
  exports = NHK
else if window?
  window.NHK = NHK

if __filename? and process.mainModule.filename is __filename
  nhk = new NHK
  nhk.getNews (err, news) ->
    console?.log news
