# encoding: utf-8
require 'pygments'

module Wst
  class HTMLwithPygments < Redcarpet::Render::XHTML
    def block_code(code, language)
      Pygments.highlight(code, :lexer => language)
    end
  end
end
