$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'tdiary/core_ext'
require 'tdiary/comment_manager'
require 'tdiary/referer_manager'
require 'tdiary/style'
require 'tdiary/style/org'

TDiary::Style::OrgDiary.send(:include, TDiary::Style::BaseDiary)
TDiary::Style::OrgDiary.send(:include, TDiary::Style::CategorizableDiary)
TDiary::Style::OrgSection.send(:include, TDiary::Style::BaseSection)
