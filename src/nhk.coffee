request   = require 'request'
parse_rss = require 'parse-rss'
events    = require 'eventemitter2'

class NHK extends events.EventEmitter2
  getNews: (callback) ->
    url = 'http://www3.nhk.or.jp/rss/news/cat0.xml'
    parse_rss url, (err, rss) ->
      if err
        callback err
        return
      news = []
      for i in rss
        news.push {url: i.link, title: i.title}
      callback null, news

if module? and module.exports?
  module = module.exports = NHK
else
  window.NHK = NHK
