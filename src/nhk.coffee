async      = require 'async'
request    = require 'request'
FeedParser = require 'feedparser'
cheerio    = require 'cheerio'
events     = require 'eventemitter2'
_          = require 'lodash'

class NHK extends events.EventEmitter2

  constructor: ->
    @rssUrls = {
      "主要ニュース": "http://www3.nhk.or.jp/rss/news/cat0.xml",
      "社会": "http://www3.nhk.or.jp/rss/news/cat1.xml",
      "科学・医療": "http://www3.nhk.or.jp/rss/news/cat3.xml",
      "政治": "http://www3.nhk.or.jp/rss/news/cat4.xml",
      "経済": "http://www3.nhk.or.jp/rss/news/cat5.xml",
      "国際": "http://www3.nhk.or.jp/rss/news/cat6.xml",
      "スポーツ": "http://www3.nhk.or.jp/rss/news/cat7.xml",
      "文化・エンタメ": "http://www3.nhk.or.jp/rss/news/cat2.xml",
      "LIVE": "http://www3.nhk.or.jp/rss/news/cat-live.xml"
    }

  getAllNews: (callback) ->
    async.map Object.keys(@rssUrls), @getNews, (err, results) ->
      callback err, _.uniq _.flatten results

  getNews: (category, callback) =>
    throw new Error('argument error') if typeof callback isnt 'function'
    url = @rssUrls[category]
    console.log url
    unless url
      callback "#{category} is not valid category"
      return
    news = []
    feed = request(url).pipe(new FeedParser)
    feed .on 'error', (err) ->
      callback err
    feed.on 'data', (chunk) ->
      news.push {url: chunk.link, title: chunk.title}
    feed.on 'end', ->
      callback null, news

  hasVideo: (url, callback) ->
    throw new Error('argument error') if typeof callback isnt 'function'
    request url, (err, res, body) ->
      if err
        callback err
        return
      $ = cheerio.load body
      callback null, ($('#news_video').text().length > 0)

if exports?
  exports = NHK
else if window?
  window.NHK = NHK

if __filename? and process.mainModule.filename is __filename
  nhk = new NHK
  nhk.getAllNews (err, news) ->
    console.log news
    console.log "#{news.length} news"

  return

  for category in ["主要ニュース", "社会"]
    nhk.getNews "主要ニュース", (err, news) ->
      console.log news
      for i in news
        nhk.hasVideo i.url, (err, has_video) ->
          console.log i.url
          console.log has_video
