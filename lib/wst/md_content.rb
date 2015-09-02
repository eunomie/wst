# encoding: utf-8
require 'wst/content'
require 'wst/configuration'

module Wst
  class MdContent < Content
    @@matcher = /^(.+\/)*(\d+-\d+-\d+)?-?(.*)(\.[^.]+)$/

    def initialize file_path
      super file_path

      m, cats, date, slug, ext = *file_path.match(@@matcher)
      @cats = cats
      @date = Time.parse(date) if date
      @slug = slug
      @ext = ext
    end

    def date
      @date
    end

    def raw_content
      if useDefaultLinks?
        content_with_links
      else
        @plain_content
      end
    end

    def self.matcher
      @@matcher
    end

    protected

    def content_with_links
      @plain_content + defaultLinks
    end

    def useDefaultLinks?
      if @datas.has_key? 'nolinks'
        @datas['nolinks'] == 'true'
      else
        true
      end
    end
  end
end
