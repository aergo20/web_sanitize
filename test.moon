-- tests pulled from:
-- * https://www.owasp.org/index.php/XSS_Filter_Evasion_Cheat_Sheet

tests = {
  {
    "this string has no html"
    "this string has no html"
  }

  {
    '<li><i>Hello world</i></li>'
    '<li><i>Hello world</i></li>'
  }

  {
    '<li><i>Hello world</li>'
    '<li><i>Hello world</i></li>'
  }

  {
    '<!-- comment -->Hello'
    '&lt;!-- comment --&gt;Hello'
  }

  {
    '<pre/>'
    '<pre/>'
  }

  {
    '<h1 title="yes"></h1>'
    '<h1 title="yes"></h1>'
  }

  {
    "<h1 title='yes'></h1>"
    "<h1 title='yes'></h1>"
  }

  {
    "<h1 title=yes></h1>"
    '<h1 title=yes></h1>'
  }

  {
    "<h1 TITLE=yes></h1>"
    '<h1 TITLE=yes></h1>'
  }

  {
    '<a href="http://leafo.net"></a>'
    '<a href="http://leafo.net" rel="nofollow"></a>'
  }

  {
    '<a href="https://leafo.net"></a>'
    '<a href="https://leafo.net" rel="nofollow"></a>'
  }

  {
    '<a href="mailto:someone@example.com">Send email</a>'
    '<a href="mailto:someone@example.com" rel="nofollow">Send email</a>'
  }

  {
    'hello <script dad="world"><b>yes</b></b>'
    'hello &lt;script dad=&quot;world&quot;&gt;<b>yes</b>&lt;/b&gt;'
  }

  {
    "<IMG color='red'></IMG>"
    '<IMG></IMG>'
  }

  {
    "<br>"
    '<br>'
  }

  {
    "<pre><br><img></pre>"
    '<pre><br><img></pre>'
  }


  -- already escaped
  {
    "hello &amp; world"
    "hello &amp; world"
  }

  {
    "&#x27; &#x2F; &#x2f; &#65;"
    "&#x27; &#x2F; &#x2f; &#65;"
  }


  -- xss

  {
    '<SCRIPT SRC=http://ha.ckers.org/xss.js></SCRIPT>'
    '&lt;SCRIPT SRC=http://ha.ckers.org/xss.js&gt;&lt;/SCRIPT&gt;'
  }

  {
    [[<IMG SRC="javascript:alert('XSS');">]]
    '<IMG>'
  }

  {
    "<IMG SRC=javascript:alert('XSS')>"
    '&lt;IMG SRC=javascript:alert(&#x27;XSS&#x27;)&gt;'
  }

  {
    "<IMG SRC=JaVaScRiPt:alert('XSS')>"
    '&lt;IMG SRC=JaVaScRiPt:alert(&#x27;XSS&#x27;)&gt;'
  }

  {
    [[<IMG SRC=`javascript:alert("RSnake says, 'XSS'")`>]]
    '&lt;IMG SRC=`javascript:alert(&quot;RSnake says, &#x27;XSS&#x27;&quot;)`&gt;'
  }

  {
    '<IMG """><SCRIPT>alert("XSS")</SCRIPT>">'
    '&lt;IMG &quot;&quot;&quot;&gt;&lt;SCRIPT&gt;alert(&quot;XSS&quot;)&lt;/SCRIPT&gt;&quot;&gt;'
  }

  {
    '<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>'
    '&lt;IMG SRC=javascript:alert(String.fromCharCode(88,83,83))&gt;'
  }


  {
    [[<IMG SRC=# onmouseover="alert('xxs')">]]
    '&lt;IMG SRC=# onmouseover=&quot;alert(&#x27;xxs&#x27;)&quot;&gt;'
  }

  {
    [[<IMG SRC= onmouseover="alert('xxs')">]]
    '&lt;IMG SRC= onmouseover=&quot;alert(&#x27;xxs&#x27;)&quot;&gt;'
  }

  {
    [[<IMG onmouseover="alert('xxs')">]]
    '<IMG>'
  }

  {
    [[<IMG SRC=&#106;&#97;&#118;&#97;&#115;&#99;&#114;&#105;&#112;&#116;&#58;&#97;&#108;&#101;&#114;&#116;&#40;
&#39;&#88;&#83;&#83;&#39;&#41;>]]
    [[&lt;IMG SRC=&#106;&#97;&#118;&#97;&#115;&#99;&#114;&#105;&#112;&#116;&#58;&#97;&#108;&#101;&#114;&#116;&#40;
&#39;&#88;&#83;&#83;&#39;&#41;&gt;]]
  }

  {
    [[<IMG SRC=&#0000106&#0000097&#0000118&#0000097&#0000115&#0000099&#0000114&#0000105&#0000112&#0000116&#0000058&#0000097&
#0000108&#0000101&#0000114&#0000116&#0000040&#0000039&#0000088&#0000083&#0000083&#0000039&#0000041>]]
    [[&lt;IMG SRC=&#0000106&#0000097&#0000118&#0000097&#0000115&#0000099&#0000114&#0000105&#0000112&#0000116&#0000058&#0000097&amp;
#0000108&#0000101&#0000114&#0000116&#0000040&#0000039&#0000088&#0000083&#0000083&#0000039&#0000041&gt;]]
  }

  {
    [[<IMG SRC=&#x6A&#x61&#x76&#x61&#x73&#x63&#x72&#x69&#x70&#x74&#x3A&#x61&#x6C&#x65&#x72&#x74&#x28&#x27&#x58&#x53&#x53&#x27&#x29>]]
    [[&lt;IMG SRC=&#x6A&#x61&#x76&#x61&#x73&#x63&#x72&#x69&#x70&#x74&#x3A&#x61&#x6C&#x65&#x72&#x74&#x28&#x27&#x58&#x53&#x53&#x27&#x29&gt;]]
  }

  {
    [[<IMG SRC="jav	ascript:alert('XSS');">]]
    '<IMG>'
  }

  {
    [[<IMG SRC="jav&#x09;ascript:alert('XSS');">]]
    '<IMG>'
  }

  {
    '<SCRIPT/XSS SRC="http://ha.ckers.org/xss.js"></SCRIPT>'
    '&lt;SCRIPT/XSS SRC=&quot;http://ha.ckers.org/xss.js&quot;&gt;&lt;/SCRIPT&gt;'
  }

  {
    [[<BODY onload!#$%&()*~+-_.,:;?@[/|\]^`=alert("XSS")>]]
    [[&lt;BODY onload!#$%&amp;()*~+-_.,:;?@[/|\]^`=alert(&quot;XSS&quot;)&gt;]]
  }

  {
    '<SCRIPT/SRC="http://ha.ckers.org/xss.js"></SCRIPT>'
    '&lt;SCRIPT/SRC=&quot;http://ha.ckers.org/xss.js&quot;&gt;&lt;/SCRIPT&gt;'
  }

  {
    '<<SCRIPT>alert("XSS");//<</SCRIPT>'
    '&lt;&lt;SCRIPT&gt;alert(&quot;XSS&quot;);//&lt;&lt;/SCRIPT&gt;'
  }

  {
    [[<IMG SRC="javascript:alert('XSS')"]]
    '&lt;IMG SRC=&quot;javascript:alert(&#x27;XSS&#x27;)&quot;'
  }

  {
    [[<INPUT TYPE="IMAGE" SRC="javascript:alert('XSS');">]]
    '&lt;INPUT TYPE=&quot;IMAGE&quot; SRC=&quot;javascript:alert(&#x27;XSS&#x27;);&quot;&gt;'
  }

  {
    [[<IMG DYNSRC="javascript:alert('XSS')">]]
    '<IMG>'
  }

  {
    [[<STYLE>li {list-style-image: url("javascript:alert('XSS')");}</STYLE><UL><LI>XSS</br>]]
    '&lt;STYLE&gt;li {list-style-image: url(&quot;javascript:alert(&#x27;XSS&#x27;)&quot;);}&lt;/STYLE&gt;<UL><LI>XSS&lt;/br&gt;</li></ul>'
  }

  {
    [[<IMG SRC='vbscript:msgbox("XSS")'>]]
    '<IMG>'
  }

  {
    [[<BR SIZE="&{alert('XSS')}">]]
    '<BR>'
  }

  {
    [[<LINK REL="stylesheet" HREF="javascript:alert('XSS');">]]
    '&lt;LINK REL=&quot;stylesheet&quot; HREF=&quot;javascript:alert(&#x27;XSS&#x27;);&quot;&gt;'
  }

  {
    [[<STYLE>@import'http://ha.ckers.org/xss.css';</STYLE>]]
    '&lt;STYLE&gt;@import&#x27;http://ha.ckers.org/xss.css&#x27;;&lt;/STYLE&gt;'
  }

  {
    [[<META HTTP-EQUIV="Link" Content="<http://ha.ckers.org/xss.css>; REL=stylesheet">]]
    '&lt;META HTTP-EQUIV=&quot;Link&quot; Content=&quot;&lt;http://ha.ckers.org/xss.css&gt;; REL=stylesheet&quot;&gt;'
  }

  {
    [[<META HTTP-EQUIV="refresh" CONTENT="0;url=javascript:alert('XSS');">]]
    '&lt;META HTTP-EQUIV=&quot;refresh&quot; CONTENT=&quot;0;url=javascript:alert(&#x27;XSS&#x27;);&quot;&gt;'
  }

  {
    [[<IFRAME SRC="javascript:alert('XSS');"></IFRAME>]]
    '&lt;IFRAME SRC=&quot;javascript:alert(&#x27;XSS&#x27;);&quot;&gt;&lt;/IFRAME&gt;'
  }

  {
    [[<FRAMESET><FRAME SRC="javascript:alert('XSS');"></FRAMESET>]]
    '&lt;FRAMESET&gt;&lt;FRAME SRC=&quot;javascript:alert(&#x27;XSS&#x27;);&quot;&gt;&lt;/FRAMESET&gt;'
  }

  {
    [[<TABLE BACKGROUND="javascript:alert('XSS')">]]
    '<TABLE></table>'
  }

  {
    [[<iframe src=http://ha.ckers.org/scriptlet.html <]]
    '&lt;iframe src=http://ha.ckers.org/scriptlet.html &lt;'
  }

  -- malformed

  {
    "<b color=red>hi</b wazzaup"
    '<b>hi&lt;/b wazzaup</b>'
  }

  {
    "<b title='yeah'"
    '&lt;b title=&#x27;yeah&#x27;'
  }

}

import sanitize_html from require "web_sanitize"

describe "web_sanitize", ->
  for i, {input, output} in ipairs tests
    it "#{i}: should match", ->
      assert.are.equal output, sanitize_html(input)
