# rakuten.rb $Revision: 3 $
# Copyright (C) 2009 Michitaka Ohno <elpeo@mars.dti.ne.jp>
# You can redistribute it and/or modify it under GPL2.

# ja/rakuten.rb
@rakuten_label_conf ='楽天市場'
@rakuten_label_did = 'デベロッパーID'
@rakuten_label_aid = 'アフィリエイトID'
@rakuten_label_imgsize = '表示するイメージのサイズ'
@rakuten_label_medium = '普通'
@rakuten_label_small = '小さい'
@rakuten_label_clearcache = 'キャッシュの削除'
@rakuten_label_clearcache_desc = 'イメージ関連情報のキャッシュを削除する(楽天上の表示と矛盾がある場合に試して下さい)'

require 'rexml/document.rb'
#require 'open-uri'
require 'net/http'
require 'kconv'

Net::HTTP.version_1_2

def rakuten_get( keyword, shop )
	cache = "#{@cache_path}/rakuten"
	Dir::mkdir( cache ) unless File::directory?( cache )
	file = shop ? "#{cache}/#{shop}_#{u( keyword )}.xml" : "#{cache}/#{u( keyword )}.xml"
	begin
		xml = File::read( file )
	rescue
		qs = []
		qs << 'developerId='+u( @conf['rakuten.did'] )
		qs << 'keyword='+u( keyword )
		qs << 'shopCode='+u( shop ) if shop
		qs << 'operation=ItemSearch'
		qs << 'version=2009-04-15'
		qs << 'hits=1'
		qs << 'availability=0'
      res = Net::HTTP.start( 'api.rakuten.co.jp' ).get( '/rws/2.0/rest?'+(qs*'&') )
		xml = res.body if res && res.body
#		xml = open( 'http://api.rakuten.co.jp/rws/2.0/rest?'+(qs*'&') ){|f| f.read}
		open( file, 'wb' ) {|f| f.write( xml )} if xml
	end
	REXML::Document.new( xml ).root if xml
end

def rakuten_get_image( doc )
	img = Struct.new( :size, :src, :width, :height ).new
	if @conf['rakuten.imgsize'] == 1 then
		img.size = 'small'
		img.width = img.height = 64
	else
		img.size = 'medium'
		img.width = img.height = 128
	end
	if doc.elements["Body/itemSearch:ItemSearch/Items/Item/imageFlag"].text.to_i == 1 then
		img.src = doc.elements["Body/itemSearch:ItemSearch/Items/Item/#{img.size}ImageUrl"].text
	else
		img.src = "http://image.www.rakuten.co.jp/com/img/icon/item_none.gif"
	end
	img
end

def rakuten_get_price( doc )
	begin
		r = doc.elements['Body/itemSearch:ItemSearch/Items/Item/itemPrice'].text
		nil while r.gsub!(/(.*\d)(\d\d\d)/, '\1,\2')
		"\\"+r
	rescue
		'(no price)'
	end
end

def rakuten_get_shop( doc )
	begin
		@conf.to_native( doc.elements['Body/itemSearch:ItemSearch/Items/Item/shopName'].text )
	rescue
		'-'
	end
end

def rakuten_get_html( keyword, shop, pos )
	doc = rakuten_get( keyword, shop )
	return unless doc && doc.elements['Body/itemSearch:ItemSearch/count'].text.to_i > 0
	name = @conf.to_native( doc.elements["Body/itemSearch:ItemSearch/Items/Item/itemName"].text )
	link = doc.elements["Body/itemSearch:ItemSearch/Items/Item/itemUrl"].text
	if @conf['rakuten.aid'] then
		link = "http://hb.afl.rakuten.co.jp/hgc/#{@conf['rakuten.aid']}/?pc=#{u( link )}"
	end
	img = rakuten_get_image( doc )
	r = %Q[<a href="#{h( link )}">]
	r << %Q[<img class="#{pos}" src="#{h( img.src )}" alt="#{h( name )}" title="#{h( name )}">] if img.src
	r << h( name )
	r << %Q[</a>]
end

def rakuten_image( keyword, shop = nil )
	rakuten_get_html( keyword, shop, 'amazon' )
end

def rakuten_image_left( keyword, shop = nil )
	rakuten_get_html( keyword, shop, 'left' )
end

def rakuten_image_right( keyword, shop = nil )
	rakuten_get_html( keyword, shop, 'right' )
end

def rakuten_detail( keyword, shop = nil )
	doc = rakuten_get( keyword, shop )
   return unless doc
   return unless doc.elements['Body/itemSearch:ItemSearch/count']
	return unless doc.elements['Body/itemSearch:ItemSearch/count'].text.to_i > 0
	name = @conf.to_native( doc.elements["Body/itemSearch:ItemSearch/Items/Item/itemName"].text )
	link = doc.elements["Body/itemSearch:ItemSearch/Items/Item/itemUrl"].text
	if @conf['rakuten.aid'] then
		link = "http://hb.afl.rakuten.co.jp/hgc/#{@conf['rakuten.aid']}/?#{@conf.mobile_agent ? 'm' : 'pc'}=#{u( link )}"
	end
	img = rakuten_get_image( doc )
	price = rakuten_get_price( doc )
	shop = rakuten_get_shop( doc )
	<<-HTML
	<a class="amazon-detail" href="#{h( link )}"><span class="amazon-detail">
		<img class="amazon-detail left" src="#{h( img.src )}"
		alt="#{h( name )}" title="#{h( name )}">
      <span class="amazon-detail-desc">
	      <span class="amazon-title">#{h( name )}</span><br>
	      <span class="amazon-label">#{h( shop )}</span><br>
	      <span class="amazon-price">#{h( price )}</span>
      </span><br style="clear: left">
      </span></a>
	HTML
end

add_conf_proc( 'rakuten', @rakuten_label_conf ) do
	rakuten_conf_proc
end

def rakuten_conf_proc
	if @mode == 'saveconf' then
		@conf['rakuten.imgsize'] = @cgi.params['rakuten.imgsize'][0].to_i
		if @cgi.params['rakuten.clearcache'][0] == 'true' then
			Dir["#{@cache_path}/rakuten/*"].each do |cache|
				File::delete( cache.untaint )
			end
		end
		if @cgi.params['rakuten.did'][0].empty? then
			@conf['rakuten.did'] = nil
		else
			@conf['rakuten.did'] = @cgi.params['rakuten.did'][0]
		end
		if @cgi.params['rakuten.aid'][0].empty? then
			@conf['rakuten.aid'] = nil
		else
			@conf['rakuten.aid'] = @cgi.params['rakuten.aid'][0]
		end
	end

	<<-HTML
	<h3>#{@rakuten_label_did}</h3>
	<p><input name="rakuten.did" value="#{h( @conf['rakuten.did'] )}" size="100"></p>
	<h3>#{@rakuten_label_aid}</h3>
	<p><input name="rakuten.aid" value="#{h( @conf['rakuten.aid'] )}" size="100"></p>
	<h3>#{@rakuten_label_imgsize}</h3>
	<p><select name="rakuten.imgsize">
		<option value="0"#{" selected" if @conf['rakuten.imgsize'] == 0}>#{@rakuten_label_medium}</option>
		<option value="1"#{" selected" if @conf['rakuten.imgsize'] == 1}>#{@rakuten_label_small}</option>
	</select></p>
	<h3>#{@rakuten_label_clearcache}</h3>
	<p><label for="rakuten.clearcache"><input type="checkbox" id="rakuten.clearcache" name="rakuten.clearcache" value="true">#{@rakuten_label_clearcache_desc}</label></p>
	HTML
end
