# -*- coding: utf-8; -*-
#
# org.rb: Org style class
#
# if you want to use this style, add @style into tdiary.conf below:
#
#    @style = 'Org'
#
# Copyright (C) 2015 Youhei SASAKI <uwabami@gfd-dennou.org>
# You can redistribute it and/or modify it under MIT/X11

require 'org-ruby'
require 'pygments'

module TDiary
	module Style
		class OrgSection
			def initialize(fragment, author = nil)
				@author = author
				@subtitle, @body = fragment.split(/\n/, 2)
				@body ||= ''
				@categories = get_categories
				@stripped_subtitle = strip_subtitle
				@subtitle_to_html = @subtitle ? to_html('* ' + @subtitle).strip.gsub(/\A<h\d>|<\/h\d>\z/io, '') : nil
				@stripped_subtitle_to_html = @stripped_subtitle ? to_html(@stripped_subtitle).strip.gsub(/\A<h\d>|<\/h\d>\z/io, '') : nil
				@body_to_html = to_html(@body)
			end

			def subtitle=(subtitle)
				@subtitle = (subtitle || '').sub(/^# /,"\##{categories_to_string} ")
				@strip_subtitle = strip_subtitle
			end

			def categories=(categories)
				@subtitle = "#{categories_to_string} " + (strip_subtitle || '')
				@strip_subtitle = strip_subtitle
			end

			def to_src
				r = ''
				r << "#{@subtitle}\n" if @subtitle
				r << @body
			end

			def do_html4(date, idx, opt)
				subtitle = to_html(@subtitle)
				subtitle.sub!( %r!<h3>(.+?)</h3>!m ) do
					"<h3><%= subtitle_proc( Time.at( #{date.to_i} ), #{$1.dump.gsub( /%/, '\\\\045' )} ) %></h3>"
				end
				if opt['multi_user'] and @author then
					subtitle.sub!(/<\/h3>/,%Q|[[#{@author}]]</h3>|)
				end
				r = subtitle
				r << @body_to_html
			end

			private

			def to_html(string)
				r = string.dup
				renderer = Orgmode::Parser.new(string, {markup_file: File.dirname(__FILE__) + '/org/html_tags.yml', skip_syntax_highlight: false } )
				r = renderer.to_html
				# for tDiary plugin
				r = r.gsub(/\(\(%(.+?)%\)\)/m,'<%=\1%>')
				r = r.gsub(/&lt;/,'<').gsub(/&gt;/,'>')
				r = r.gsub('&#8216;','\'').gsub('&#8217;','\'')
				r = r.gsub('&#8220;','"').gsub('&#8221;','"')
			end

			def get_categories
				return [] unless @subtitle
				org = Orgmode::Parser.new(@subtitle, {markup_file: File.dirname(__FILE__) + '/org/html_tags.yml', skip_syntax_highlight: false} )
				unless org.headlines[0] == nil
					cat = org.headlines[0].tags.flatten
				else
					cat = []
				end
				return cat
			end

			def strip_subtitle
				unless @subtitle
					return nil
				else
					return '* ' + Orgmode::Parser.new(@subtitle, {markup_file: File.dirname(__FILE__) + '/org/html_tags.yml'} ).headlines[0].headline_text
				end
			end

		end

		class OrgDiary
			def initialize(date, title, body, modified = Time.now)
				init_diary
				replace( date, title, body )
				@last_modified = modified
			end

			def style
				'Org'
			end

			def append(body, author = nil)
				in_code_block = false
				section = nil
				body.each_line do |l|
					case l
					when /^\*[^\*]/
						if in_code_block
							section << l
						else
							@sections << OrgSection.new(section, author) if section
							section = l
						end
					when /^#\+/
						in_code_block = !in_code_block
						section << l
					else
						section = '' unless section
						section << l
					end
				end
				if section
					section << "\n" unless section =~ /\n\n\z/
					@sections << OrgSection.new(section, author)
				end
				@last_modified = Time.now
				self
			end

			def add_section(subtitle, body)
				@sections = OrgSection.new("* #{subtitle}\n\n#{body}")
				@sections.size
			end
		end

	end
end

# Local Variables:
# mode: ruby
# indent-tabs-mode: t
# tab-width: 3
# ruby-indent-level: 3
# End:
