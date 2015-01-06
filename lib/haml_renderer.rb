# encoding: utf-8
require 'renderer'
require 'haml'
require 'configuration'

module Wst
  class HamlRenderer < Renderer
    protected

    def render_layout
      hamlcontent = HamlContent.new layout_path, @content, render_content
      renderer = HamlRenderer.new hamlcontent
      renderer.render
    end

    def render_content
      haml_engine.render(@content) do
        @content.sub_content
      end
    end

    def haml_engine
      Haml::Engine.new @content.raw_content
    end
  end
end
