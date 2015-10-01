# encoding: utf-8
require 'wst/renderer'
require 'haml'
require 'wst/configuration'

module Wst
  class HamlRenderer < Renderer
    protected

    def render_layout
      hamlcontent = HamlContent.new layout_path, @content, render_content
      renderer = HamlRenderer.new hamlcontent, @wst
      renderer.render
    end

    def render_content
      haml_engine.render(@content, :contents => @wst.contents) do
        @content.sub_content
      end
    end

    def haml_engine
      Haml::Engine.new @content.raw_content
    end
  end

  class XmlRenderer < HamlRenderer
  end
end
