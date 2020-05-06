if /\A(?:latest|day|month|nyear|preview)\z/ =~ @mode then
        add_header_proc do
                <<-HTML
                <link href="//google-code-prettify.googlecode.com/svn/trunk/src/prettify.css" type="text/css" rel="stylesheet">
                <script type="text/javascript" src="//google-code-prettify.googlecode.com/svn/trunk/src/prettify.js"></script>
                <script type="text/javascript"><!--
                        function google_prettify(){
                                prettyPrint();
                        }
                        if(window.addEventListener){
                                window.addEventListener("load",google_prettify,false);
                        }else if(window.attachEvent){
                                window.attachEvent("onload",google_prettify);
                        }else{
                                window.onload=google_prettify;
                        }
                // --></script>
                HTML
        end
end

def code_prettify(src_code)
   %Q|<div><pre class="prettyprint">#{CGI::escapeHTML(src_code)}</pre></div>\n|
end
