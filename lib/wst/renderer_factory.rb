# encoding: utf-8
require 'wst/post'
require 'wst/page'
require 'wst/haml_content'
require 'wst/md_renderer'
require 'wst/haml_renderer'

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
