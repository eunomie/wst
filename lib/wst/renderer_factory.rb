# encoding: utf-8
require 'wst/post'
require 'wst/page'
require 'wst/haml_content'
require 'wst/md_renderer'
require 'wst/haml_renderer'

module Wst
  module RendererFactory
    module_function

    def for content, wst
      send content.class.name.split('::').last.downcase.to_sym, content, wst
    end

    def post content, wst
      MdRenderer.new content, wst
    end

    def mdpage content, wst
      MdRenderer.new content, wst
    end

    def hamlpage content, wst
      HamlRenderer.new content, wst
    end

    def xmlpage content, wst
      XmlRenderer.new content, wst
    end

    def hamlcontent content, wst
      HamlRenderer.new content, wst
    end
  end
end
