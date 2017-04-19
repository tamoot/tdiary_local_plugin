# -*- coding: utf-8 -*-
#
# aa.rb - display ascii art.
#
# Copyright (C) 2010, tamoot <tamoot+tdiary@gmail.com>
# You can redistribute it and/or modify it under GPL2.
#

def aa(str)
   %Q|<pre class="aa">#{str}</pre>|
end

add_header_proc do
   <<-AA_CSS
	<style type="text/css">
	<!--
	pre.aa {
      font-family: IPAMonaPGothic,'ＭＳ Ｐゴシック',sans-serif;
      font-size  : 16px;
      line-height: 18px;
   }
	@media screen { /* for MacIE */
		pre.aa {
		   overflow: auto; /* remove scroll bar */
	   }
   	* html span.aa { /* for IE */
   		width: 100%;
   	}
	}
	--></style>
   AA_CSS
end

# Local Variables:
# mode: ruby
# indent-tabs-mode: t
# tab-width: 3
# ruby-indent-level: 3
# End:
# vim: ts=3
