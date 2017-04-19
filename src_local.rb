def src_local(file_name)
Dir::pwd
  %Q|<div class="code"><pre>#{h(File::readlines( "/home/harabu/workspace/svn_local/trunk/tdiary/plugin/#{file_name}" ).join )}</pre></div>|
end
