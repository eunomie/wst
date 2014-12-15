# encoding: utf-8
require 'haml_helpers_wlt_extensions'
require 'post'
require 'page'
require 'renderer_factory'
require 'configuration'
require "sass"
require 'logging'
require 'colored'
require 'uglifier'

class Wst
  include Logging
  include Configuration

  def generate all = false
    init
    css
    js
    content all
    pub
  end

  private

  def init
    logger.info "Clean".blue
    FileUtils.mkdir_p File.join config['path'], "_site"
    FileUtils.rm_rf Dir.glob File.join config['path'], "_site/*"
  end

  def css
    return unless config.has_key? "assets"
    return unless config["assets"].has_key? "css"
    cssconf = config["assets"]["css"]
    return unless cssconf.kind_of? Array

    logger.info "Css".blue
    cssconf.each do |cssname|
      logger.info "  #{cssname}"
      compile_css cssname
    end
  end

  def kss
    return unless config.has_key? "assets"
    return unless config["assets"].has_key? "css"
    cssconf = config["assets"]["css"]
    return unless cssconf.kind_of? Array

    logger.info "KSS".blue
    cssconf.each do |cssname|
      logger.info "  #{cssname}"
      compile_css_expanded cssname
    end
  end

  def js
    return unless config.has_key? "assets"
    return unless config["assets"].has_key? "js"
    jsconf = config["assets"]["js"]
    return unless jsconf.kind_of? Array

    logger.info "Js".blue
    jsconf.each do |jsname|
      logger.info "  #{jsname}"
      compile_js jsname
    end
  end

  def compile_js jsname
    lines = read_and_expand jsname
    js = lines.flatten.join
    #compiled = Uglifier.compile js
    compiled = js
    File.open("#{config['path']}/_site/#{jsname.split('/').last}.js", "w") { |f| f.write(compiled) }
  end

  def read_and_expand jsname
    jsfile = File.join File.join(config['path'], '_js', "#{jsname}.js")
    return [] unless File.exists? jsfile
    content = File.read jsfile
    lines = content.lines.inject([]) do |lines, line|
      if line =~ /\/\/=\srequire\s['"](.*)['"]/
        lines << read_and_expand("#{$1}")
      else
        lines << line
      end
    end
  end

  def content all
    logger.info "Content".blue
    contents(all).each do |doc|
      logger.info "  #{doc.url}"
      renderer = RendererFactory.for doc
      renderer.write_to_site
    end
  end

  def pub
    logger.info "Pub".blue

    outdir = File.join(config['path'], '_site')
    indir = File.join(config['path'], '_pub', '.')

    FileUtils.cp_r indir , outdir
    hidden = Dir.glob("#{indir}*").select do |file|
      File.basename(file) != '.' && File.basename(file) != '..'
    end
    FileUtils.cp_r hidden , outdir
  end

  def contents all
    return all_content if all
    all_content.select { |c| c.published }
  end

  def all_content
    [Post.all, Page.all].flatten
  end

  def compile_css cssname
    cssfile = get_css cssname
    return if cssfile.nil?
    sassengine = Sass::Engine.for_file(cssfile, :syntax => sass_syntax(cssfile), :style => :compressed)
    css = sassengine.render

    File.open("#{config['path']}/_site/#{cssname.split('/').last}.css", "w") { |f| f.write(css) }
  end

  def compile_css_expanded cssname
    cssfile = get_css cssname
    return if cssfile.nil?
    sassengine = Sass::Engine.for_file(cssfile, :syntax => sass_syntax(cssfile), :style => :expanded)
    css = sassengine.render

    File.open("#{config['path']}/_kss/#{cssname.split('/').last}.css", "w") { |f| f.write(css) }
  end

  def get_css cssname
    Dir.glob(File.join(config['path'], '_css', "#{cssname}.*")).first
  end

  def sass_syntax css
    File.extname(css).delete('.').to_sym
  end
end
