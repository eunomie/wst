# encoding: utf-8
require 'post'
require 'page'
require 'haml_content'
require 'md_renderer'
require 'haml_renderer'

module Wst
  module RendererFactory
    module_function

    def for content
      send content.class.name.split('::').last.downcase.to_sym, content
    end

    def post content
      MdRenderer.new content
    end

    def mdpage content
      MdRenderer.new content
    end

    def hamlpage content
      HamlRenderer.new content
    end

    def hamlcontent content
      HamlRenderer.new content
    end

  end
end
