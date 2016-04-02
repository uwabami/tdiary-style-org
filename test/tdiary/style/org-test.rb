# coding: utf-8
require 'test_helper'

class TestOrgDiary < Test::Unit::TestCase
  def setup
    @diary = TDiary::Style::OrgDiary.new(Time.at( 1041346800 ), "TITLE", "")
  end

  class Append < self
    def setup
      super
      @source = <<-'EOF'
* Title                                                         :DEBIAN:COMP:
  honbun
  - list1
    - nest list
  - list2

  1. enumlist1
  2. enumlist2
     - nest list1
       - nest nest list
     - nest list2
  3. enumlist3

** subTitle
  honbun
      EOF
      @diary.append(@source)
    end

    def test_html
        @html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "Title" ) %></h3>
<p>honbun</p>
<ul>
  <li>list1
    <ul>
      <li>nest list</li>
    </ul>
  </li>
  <li>list2</li>
</ul>
<ol>
  <li>enumlist1</li>
  <li>enumlist2
    <ul>
      <li>nest list1
        <ul>
          <li>nest nest list</li>
        </ul>
      </li>
      <li>nest list2</li>
    </ul>
  </li>
  <li>enumlist3</li>
</ol>
<h4>subTitle</h4>
<p>honbun</p>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
        EOF
        assert_equal(@html, @diary.to_html)
    end

    def test_source
      assert_equal(@source, @diary.to_src)
    end

  end # Append

  class Replace < self
    def setup
      super
      @source = <<-'EOF'
* Title                                                         :DEBIAN:COMP:
  honbun

** subTitle
  honbun
      EOF
      @diary.append(@source)

      @replaced = <<-'EOF'
* replaceTitle                                                  :DEBIAN:COMP:
  replace

** replacesubTitle
  replacehonbun
      EOF
    end

    def test_replace
      @diary.replace(Time.at( 1041346800 ), "TITLE", @replaced)
      @html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "replaceTitle" ) %></h3>
<p>replace</p>
<h4>replacesubTitle</h4>
<p>replacehonbun</p>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
      EOF
      assert_equal(@html, @diary.to_html)
    end

  end # Replace

  def test_link
    @source = <<-'EOF'
* subTitle

  - [[https://www.google.com][google]]
EOF
    @diary.append(@source)
    @html = <<-EOF
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<ul>
  <li><a href="https://www.google.com">google</a></li>
</ul>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
    EOF
    assert_equal(@html, @diary.to_html)
  end # link

  def test_image_link
    @source = <<-EOF
* Title

- [[http://www.google.com/logo.jpg]]
    EOF
    @diary.append(@source)
    @html = <<-EOF
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "Title" ) %></h3>
<ul>
  <li><img src="http://www.google.com/logo.jpg" alt="http://www.google.com/logo.jpg" /></li>
</ul>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
    EOF
    assert_equal(@html, @diary.to_html)
  end # image link

  def test_plugin_syntax
    @source = <<-'EOF'
* Title
((%plugin 'val'%))

((%plugin "val", 'val'%))

    EOF
    @diary.append(@source)

    @html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "Title" ) %></h3>
<p><%=plugin 'val'%></p>
<p><%=plugin "val", 'val'%></p>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
    EOF
    assert_equal(@html, @diary.to_html)
  end

  def test_plugin_syntax_with_url
    @source = <<-'EOF'
* Title
((%plugin 'http://www.example.com/foo.html', "https://www.example.com/bar.html"%))

    EOF
    @diary.append(@source)

    @html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "Title" ) %></h3>
<p><%=plugin 'http://www.example.com/foo.html', "https://www.example.com/bar.html"%></p>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
    EOF
    assert_equal(@html, @diary.to_html)
  end

  def test_code_syntax_highlighting
    @source = <<-'EOF'
* Title
  #+BEGIN_SRC emacs-lisp
    (require 'nil)
  #+END_SRC
** SubTitle
   #+BEGIN_SRC ruby
     def test
       return nil
     end
   #+END_SRC
    EOF
    @diary.append(@source)

    @html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "Title" ) %></h3>
<div class="highlight"><pre><span class="p">(</span><span class="nf">require</span> <span class="ss">&#39;nil</span><span class="p">)</span>
</pre></div>
<h4>SubTitle</h4>
<div class="highlight"><pre><span class="k">def</span> <span class="nf">test</span>
  <span class="k">return</span> <span class="kp">nil</span>
<span class="k">end</span>
</pre></div>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
    EOF
    assert_equal(@html, @diary.to_html)
  end

end
