# encoding: utf-8
require 'haml'
require 'haml_content'
require 'configuration'
require 'time'
require 'html_truncator'

module Haml
  module Helpers
    @@wlt_extensions_defined = true

    module WltExtensions
      include Configuration

      def link_to name, content, ext = 'html'
        "<a href='#{url_for(content, ext)}'>#{name}</a>"
      end

      #def link_to_if condition, name, content, ext = 'html'
      #  link_to_unless !condition, name, content, ext
      #end

      #def link_to_unless condition, name, content, ext = 'html'
      #  if condition
      #    if block_given?
      #      capture_haml &block
      #    else
      #      CGI.escape name
      #    end
      #  else
      #    link_to name, content, ext
      #  end
      #end

      def url content, ext = 'html'
        if content.is_a? String
          url_for_string content, ext
        else
          url_for_string content.url, ext
        end
      end

      def render opts = {}
        engine = Haml::Engine.new partial_haml_content(opts[:partial]).raw_content
        engine.render self
      end

      def formated_date date
        date.strftime("%d/%m/%Y")
      end

      def spanify str
        str.gsub(/./) {|c| "<span>#{c}</span>"}
      end

      def excerpt striphtml = false, length = 30, ellipsis = "…"
        truncate = HTML_Truncator.truncate deep_content.sub_content, length, :ellipsis => ellipsis
        if striphtml
          truncate.gsub(/<[^>]+>/, '')
        else
          truncate.gsub(/<\/?img[^>]*>/, '')
        end
      end


      private

      def partial_path partial
        default_path = File.join config['path'], '_layouts', "#{partial}.haml"
        File.join File.dirname(default_path), "_#{File.basename(default_path)}"
      end

      def partial_haml_content partial
        HamlContent.new partial_path(partial), content
      end

      def url_for_string url, ext
        path = url
        path += ".#{ext}" if !url.empty? && File.extname(url).empty?
        "#{config['site_url']}/#{path}"
      end
    end

    include WltExtensions
  end
end
