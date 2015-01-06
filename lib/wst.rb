# encoding: utf-8
require 'haml_helpers_wlt_extensions'
require 'post'
require 'page'
require 'renderer_factory'
require 'css_renderer'
require 'configuration'
require 'logging'
require 'colored'
require 'uglifier'

module Wst
  class Wst
    include Logging
    include Configuration

    def initialize
      @css_renderer = CssRenderer.new
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

    def js
      return unless config.has_key? 'assets'
      return unless config['assets'].has_key? 'js'
      js_conf = config['assets']['js']
      return unless js_conf.kind_of? Array

      logger.info 'Js'.blue
      js_conf.each do |js_name|
        logger.info "  #{js_name}"
        compile_js js_name
      end
    end

    # @param [String] js_name Name of the js file to compile
    def compile_js(js_name)
      lines = read_and_expand js_name
      js = lines.flatten.join
      compiled = unless config['debug'] then
        Uglifier.compile js
      else
        js
      end
      File.open("#{config['path']}/_site/#{js_name.split('/').last}.js", 'w') { |f| f.write(compiled) }
    end

    # @param [String] js_name Name of the js file to compile
    def read_and_expand(js_name)
      js_file = File.join File.join(config['path'], '_js', "#{js_name}.js")
      return [] unless File.exists? js_file
      content = File.read js_file
      content.lines.inject([]) do |lines, line|
        if line =~ /\/\/=\srequire\s['"](.*)['"]/
          lines << read_and_expand("#{$1}")
        else
          lines << line
        end
      end
    end

    # @param [Boolean] all Generate all content or only published content
    def content(all)
      logger.info 'Content'.blue
      contents(all).each do |doc|
        logger.info "  #{doc.url}"
        renderer = RendererFactory.for doc
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

    # @param [Boolean] all Get all content or only published content
    # @return [Array<Content>] Contents
    def contents(all)
      return all_content if all
      all_content.select { |c| c.published }
    end

    # @return [Array<Content>] All post and page content
    def all_content
      [Post.all, Page.all].flatten
    end
  end
end
