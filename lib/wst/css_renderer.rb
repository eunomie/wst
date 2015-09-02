# encoding: utf-8
require 'wst/configuration'
require 'wst/logging'
require 'sass'

module Wst
  class CssRenderer
    include Logging
    include Configuration

    def generate_all
      logger.info 'Css'.blue
      css_conf.each do |css_name|
        logger.info "  #{css_name}"
        compile css_name
      end
    end

    # @param [String] css_name Name of the css to compile
    def compile(css_name)
      css_file = get_css css_name
      return if css_file.nil?
      sass_style = unless config['debug'] then
                     :compressed
                   else
                     :expanded
                   end
      output_file = "#{config['path']}/_site/#{css_name.split('/').last}.css"
      File.open(output_file, 'w') do |f|
        f.write css(css_file, sass_style)
      end
    end

    private
    # @return [Array<String>] Array of css configurations.
    def css_conf
      if config.has_key?('assets') &&
          config['assets'].has_key?('css') &&
          config['assets']['css'].kind_of?(Array)
        config['assets']['css']
      else
        []
      end
    end

    # @param [String] css_file css file to compile
    # @param [Symbol] sass_style Style for Sass
    def css(css_file, sass_style)
      sass_engine = Sass::Engine.for_file(css_file, :syntax => sass_syntax(css_file), :style => sass_style)
      sass_engine.render
    end

    # Get the css file path.
    # @param [String] css_name Name of the css relatively to _css directory
    # @return [String] Name of the css relatively to _css directory
    def get_css(css_name)
      Dir.glob(File.join(config['path'], '_css', "#{css_name}.*")).first
    end

    # Get syntax (sass or scss) for a file
    # @param [String] css Name of the file
    # @return [symbol] :sass or :scss
    def sass_syntax(css)
      File.extname(css).delete('.').to_sym
    end
  end
end
