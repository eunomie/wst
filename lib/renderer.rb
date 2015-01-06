# encoding: utf-8
require 'configuration'
require 'haml_content'
require 'fileutils'

module Wst
  class Renderer
    include Configuration

    def initialize content
      @content = content
    end

    def render
      if has_layout?
        render_layout
      else
        render_content
      end
    end

    def write_to_site
      out = File.join config['path'], '_site', @content.url
      FileUtils.mkdir_p File.dirname out
      write_to out
    end

    protected

    def write_to out
      File.open(out, 'w') { |f| f.write render }
    end

    def render_layout
    end

    def render_content
      @content.raw_content
    end

    def has_layout?
      @content.layout? && layout_exists?
    end

    def layout_path
      "#{config['path']}/_layouts/#{@content.layout}.haml"
    end

    def layout_exists?
      File.exists? layout_path
    end
  end
end
