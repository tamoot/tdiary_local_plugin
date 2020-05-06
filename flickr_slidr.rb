def flickr_slidr(set, frame_width=300, frame_height=300)
   ret = ''
   if feed? || @conf.smartphone?
      ret = %Q|<a href="//www.flickr.com/photos/tamoot/sets/#{set}/">tamoot Set #{set} on flickr.com</a>|
   else
      user = @conf['flickr.id']
      ret = %Q[<iframe align="center" src="//www.flickr.com/slideShow/index.gne?group_id=&user_id=#{user}&set_id=#{set}&text=" frameBorder="0" width="#{frame_width}" height="#{frame_height}" scrolling="no"></iframe><br/><small>Created with <a href="http://www.admarket.se" title="Admarket.se">Admarket\'s</a> <a href="http://flickrslidr.com" title="flickrSLiDR">flickrSLiDR</a>.</small>]
   end
   ret
end
alias :flickr_set :flickr_slidr
