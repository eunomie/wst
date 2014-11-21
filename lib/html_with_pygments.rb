# encoding: utf-8
require 'pygments'

class HTMLwithPygments < Redcarpet::Render::XHTML
  def block_code(code, language)
    Pygments.highlight(code, :lexer => language)
  end
end
