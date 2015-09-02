# encoding: utf-8
require 'wst/content'

module Wst
  class HamlContent < Content
    def initialize file_path, child = nil, sub_content = ''
      super file_path, child
      @sub_content = sub_content
    end

    def sub_content
      @sub_content
    end

    def deep_content
      c = self
      while !c.child.nil? && !c.child.child.nil?
        c = c.child
      end
      c
    end
  end
end
