# -*- coding: utf-8; -*-
require 'spec_helper'

describe TDiary::Style::OrgDiary do
	before do
		@diary = TDiary::Style::OrgDiary.new(Time.at( 1041346800 ), "TITLE", "")
	end

	describe '#append' do
		before do
			@source = <<-'EOF'
* subTitle                                       :Test1:Test2:
honbun

** subTitleH4
honbun

#+BEGIN_EXAMPLE
# comment in code block
#+END_EXAMPLE

EOF
			@diary.append(@source)
		end

		context 'HTML' do
			before do
				@html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<p>honbun</p>
<h4>subTitleH4</h4>
<p>honbun</p>
<pre class="example">
# comment in code block
</pre>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
				EOF
			end
			it { expect(@diary.to_html).to eq @html }
		end

		context 'CHTML' do
			before do
				@html = <<-'EOF'
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<p>honbun</p>
<h4>subTitleH4</h4>
<p>honbun</p>
<pre class="example">
# comment in code block
</pre>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
				EOF
			end
			it { expect(@diary.to_html({}, :CHTML)).to eq @html }
		end

		context 'to_src' do
			it { expect(@diary.to_src).to eq @source }
		end

	end #append

	describe '#replace' do
		before do
			source = <<-'EOF'
* subTitle
honbun

** subTitleH4
honbun

EOF
			@diary.append(source)

			replaced = <<-'EOF'
* replaceTitle                                   :Test3:Test4:
replace

** replaceTitleH4
replace

EOF
			@diary.replace(Time.at( 1041346800 ), "TITLE", replaced)

			@html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "replaceTitle" ) %></h3>
<p>replace</p>
<h4>replaceTitleH4</h4>
<p>replace</p>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
			EOF
		end
		it { expect(@diary.to_html).to eq @html }

	end #replace

	describe 'link' do
		before do
			source = <<-EOF
* subTitle

  - [[http://www.google.com]]
  - [[https://www.google.com][google]]

EOF
			@diary.append(source)
			@html = <<-EOF
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<ul>
  <li><a href="http://www.google.com">http://www.google.com</a></li>
  <li><a href="https://www.google.com">google</a></li>
</ul>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
EOF
		end
		it { expect(@diary.to_html).to eq @html }

	end # link

	describe 'plugin syntax' do
		before do
			source = <<-'EOF'
* subTitle
((%plugin 'val'%))

((%plugin "val", 'val'%))

((%plugin <<EOS, 'val'
valval
valval
vaoooo
EOS
%))

			EOF
			@diary.append(source)

			@html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<p><%=plugin 'val'%></p>
<p><%=plugin "val", 'val'%></p>
<p><%=plugin <<EOS, 'val'
  valval
  valval
  vaoooo
  EOS
  %></p>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
			EOF
		end
		it { expect(@diary.to_html).to eq @html }

	end # plugin syntax

	describe 'plugin syntax with url args' do
		before do
			source = <<-'EOF'
* subTitle
((%plugin 'http://www.example.com/foo.html', "https://www.example.com/bar.html"%))

			EOF
			@diary.append(source)

			@html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<p><%=plugin 'http://www.example.com/foo.html', "https://www.example.com/bar.html"%></p>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
			EOF
		end
		it { expect(@diary.to_html).to eq @html }

	end # 'plugin syntax with url args'


	describe 'code highlighting' do
		before do
			source = <<-'EOF'
* subTitle

#+BEGIN_SRC ruby
 def class
   @foo = 'bar'
 end
#+END_SRC
EOF
			@diary.append(source)

			@html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<div class="highlight"><pre><span></span><span class="k">def</span> <span class="nf">class</span>
  <span class="vi">@foo</span> <span class="o">=</span> <span class="s1">&#39;bar&#39;</span>
<span class="k">end</span>
</pre></div>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
EOF
		end
		it { expect(@diary.to_html).to eq @html }

	end # code highlighting

	describe 'strong, em, underline, code' do
		before do
			source = <<-'EOF'
* subTitle

文章中の *strong* はどうなるんだっけ?

文章中の /emphasis/ はどうなるんだっけ?

文章中の _underline_ はどうなるんだっけ?

文章中の =some_code= はどうなるんだっけ?

** subtitle 内の *強調* は?

	EOF
			@diary.append(source)

			@html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<p>文章中の <strong>strong</strong> はどうなるんだっけ?</p>
<p>文章中の <em>emphasis</em> はどうなるんだっけ?</p>
<p>文章中の <span class="underline">underline</span> はどうなるんだっけ?</p>
<p>文章中の <code>some_code</code> はどうなるんだっけ?</p>
<h4>subtitle 内の <strong>強調</strong> は?</h4>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
EOF
		end
		it { expect(@diary.to_html).to eq @html }

	end # strong, em, underline, code

end

# Local Variables:
# mode: ruby
# indent-tabs-mode: t
# tab-width: 3
# ruby-indent-level: 3
# End:
