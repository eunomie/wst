# encoding: utf-8
require 'renderer'
require 'renderer_factory'
require 'redcarpet'
require 'html_with_pygments'

module Wst
  class MdRenderer < Renderer
    protected

    def render_layout
      hamlcontent = HamlContent.new layout_path, @content, render_content
      renderer = RendererFactory.for hamlcontent
      renderer.render
    end

    def render_content
      markdown_renderer.render @content.raw_content
    end

    def markdown_renderer
      Redcarpet::Markdown.new(HTMLwithPygments,
        :with_toc_data => true,
        :fenced_code_blocks => true,
        :strikethrough => true,
        :autolink => true,
        :no_intra_emphasis => true,
        :tables => true)
    end
  end
end
