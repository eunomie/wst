# encoding: utf-8
require 'wst/haml_helpers_wlt_extensions'
require 'wst/post'
require 'wst/page'
require 'wst/contents'
require 'wst/renderer_factory'
require 'wst/css_renderer'
require 'wst/js_renderer'
require 'wst/configuration'
require 'wst/logging'
require 'wst/colored'
require 'uglifier'

module Wst
  class Wst
    include Logging
    include Configuration

    def initialize
      @css_renderer = CssRenderer.new
      @js_renderer = JsRenderer.new
      @contents = Contents.new
    end

    # @param [Boolean] all Generate all content or only published content
    def generate(all = false)
      init
      css
      js
      content all
      pub
    end

    # Compile all css files
    def css
      @css_renderer.generate_all
    end

    # Compile a single css file
    # @param [String] css_name Css name to compile
    def compile_css(css_name)
      @css_renderer.compile css_name
    end

    # Compile all js files
    def js
      @js_renderer.generate_all
    end

    # Compile a single js file
    # @param [String] js_name Js name to compile
    def compile_js(js_name)
      @js_renderer.compile js_name
    end

    # Get all contents
    # return Wst::Contents
    def contents
      @contents
    end

    private

    def init
      logger.info 'Clean'.blue
      FileUtils.mkdir_p File.join config['path'], '_site'
      FileUtils.rm_rf Dir.glob File.join config['path'], '_site/*'
    end

    #def kss
    #  return unless config.has_key? 'assets'
    #  return unless config['assets'].has_key? 'css'
    #  css_conf = config['assets']['css']
    #  return unless css_conf.kind_of? Array

    #  logger.info 'KSS'.blue
    #  css_conf.each do |css_name|
    #    logger.info "  #{css_name}"
    #    compile_css_expanded css_name
    #  end
    #end

    # @param [Boolean] all Generate all content or only published content
    def content(all)
      logger.info 'Content'.blue
      @contents.all(all).each do |doc|
        logger.info "  #{doc.content_url}"
        renderer = RendererFactory.for doc, self
        renderer.write_to_site
      end
    end

    def pub
      logger.info 'Pub'.blue

      out_dir = File.join(config['path'], '_site')
      in_dir = File.join(config['path'], '_pub', '.')

      FileUtils.cp_r in_dir , out_dir
      hidden = Dir.glob("#{in_dir}*").select do |file|
        File.basename(file) != '.' && File.basename(file) != '..'
      end
      FileUtils.cp_r hidden , out_dir
    end
  end
end
