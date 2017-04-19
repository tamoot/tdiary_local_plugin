require 'uri'

def tabelog_badge(url, name)
   id = File::basename(URI::parse(url).path)
   script_url = %Q|http://tabelog.com/badge/google_badge?escape=false&rcd=#{id}|
   return %Q|<div><strong><a href="#{url}" target="_blank">#{h(name)}</a></strong><br><script src="#{script_url}" type="text/javascript" charset="utf-8"></script></div>|
end
