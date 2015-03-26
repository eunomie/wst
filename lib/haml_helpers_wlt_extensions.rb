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
      include Wst::Configuration

      def link_to name, content, ext = 'html'
        "<a href='#{url(content, ext)}'>#{name}</a>"
      end

      def link_to_p name, content, ext = 'html'
        "<a href='#{url_p(content, ext)}'>#{name}</a>"
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

      def url content, ext = 'html', prefix = false
        url = if content.is_a? String
          content
        else
          content.url
        end
        url_for_string url, ext, prefix
      end

      def url_p content, ext = 'html'
        url content, ext, true
      end

      def render opts = {}
        content = unless opts[:partial].nil?
          partial_haml_content(opts[:partial], false)
        else
          partial_haml_content(opts[:partial_p], true)
        end
        engine = Haml::Engine.new content.raw_content
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

      def tr key, lang = nil
        l = if lang.nil?
          if content.prefix?
            content.prefix
          else
            'default'
          end
        else
          lang
        end
        if config['translations'].has_key?(l) && config['translations'][l].has_key?(key)
          config['translations'][l][key]
        else
          key
        end
      end

      private

      def partial_path partial, prefix
        p = "#{partial}.haml"
        p = File.join(content.prefix, p) if prefix && content.prefix?
        default_path = File.join config['path'], '_layouts', p
        File.join File.dirname(default_path), "_#{File.basename(default_path)}"
      end

      def partial_haml_content partial, prefix
        Wst::HamlContent.new partial_path(partial, prefix), content
      end

      def url_for_string url, ext, prefix
        path = url
        path += ".#{ext}" if !url.empty? && File.extname(url).empty?
        path = "#{content.prefix}/#{path}" if prefix && content.prefix?
        "#{config['site_url']}/#{path}"
      end
    end

    include WltExtensions
  end
end
