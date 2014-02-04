NHK News.app
============

auto play NHK News

- using [node-webkit](https://github.com/rogerwang/node-webkit)
- for Mac OSX

![screen shot](http://gyazo.com/231992daa43311b6b3245d01ea2ca38f.png)


## Download

download [zip archive](https://github.com/shokai/nhk-news-app/releases)


## Build

### Requirements

- Ruby
- Node.js

### Install Depedencies

    % gem install bundler
    % bundle install
    % rake npm:install


### Debug

    % rake

=> start nhk-news.app with debug-mode


### Release

build nhk-news.app

    % rake release run

