# -*- coding: utf-8 -*-
#
# twitter_tweet.rb - Show Twitter tweet
# $Id: twitter_tweets.rb 19 2010-04-30 17:20:43Z harabu $
#
# usage:
#   twitter_tweet(user_id, status, contents, image_url, time)
# 
# Copyright (C) 2009 by tamoot < http://www115.sakura.ne.jp/~harabu/diary/ >
# Distributed under the GPL.
#

def twitter_id(user_id)
  %Q|<a href="http://twitter.com/#{user_id}" link="_blank">#{user_id}さん</a>|
end

def twitter_hashtag(hash_tag)
  %Q|<a href="http://twitter.com/search?q=%23#{hash_tag}" link="_blank" alt="HashTag #{hash_tag} in Twitter">##{hash_tag}</a>|
end

def twitter_tweet(user_id, status, contents, img_url, time)
  html = <<-EOS
  EOS
  
  # replace url, user_id, hashtag
  contents.gsub!(/((?:https?|ftp|file|mailto):[A-Za-z0-9;\/?:@&=+$,\-_.!~*\'()#%]+)/){|url|%Q|<a href="#{url}">#{url}</a>|}
  contents.gsub!(/@[0-9A-Za-z_]+/){|name|%Q|<a href="http://twitter.com/#{name[1..-1]}">#{name}</a>|}
  contents.gsub!(/#[0-9A-Za-z_-]+/){|search|%Q|<a href="http://twitter.com/search?q=%23#{search.gsub('#', '')}">#{search}</a>|}

  html << %Q{ <div class="twitter_tweet"> }
  html << %Q{ <p class="twitter_text">#{contents}</p> }
  html << %Q{ <p class="twitter_timestamp"><a href="http://twitter.com/#{user_id}/status/#{status}">posted at #{time}</a></p> }
  html << %Q{ <p class="user_info"> }
  html << %Q{ <a href="http://twitter.com/#{user_id}"> }
  html << %Q{ <img alt = "" border="0" height="73" src="#{img_url}" atyle="vertical-align:middle" width="73"/> }
  html << %Q{ </a> }
  html << %Q{ <a href="http://twitter.com/#{user_id}" style="vertical-align:middle">#{user_id}</a> }
  html << %Q{ </p> }
  html << %Q{ </div> }
end
