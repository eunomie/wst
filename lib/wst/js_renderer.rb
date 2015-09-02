# encoding: utf-8
require 'wst/configuration'
require 'wst/logging'

module Wst
  class JsRenderer
    include Logging
    include Configuration

    def generate_all
      logger.info 'Js'.blue
      js_conf.each do |js_name|
        logger.info "  #{js_name}"
        compile js_name
      end
    end

    # @param [String] js_name Name of the js to compile
    def compile(js_name)
      lines = read_and_expand js_name
      js = lines.flatten.join
      compiled = unless config['debug'] then
                   Uglifier.compile js
                 else
                   js
                 end
      output_file = "#{config['path']}/_site/#{js_name.split('/').last}.js"
      File.open(output_file, 'w') do |f|
        f.write compiled
      end
    end

    private
    # @return [Array<String>] Array of js configurations.
    def js_conf
      if config.has_key?('assets') &&
          config['assets'].has_key?('js') &&
          config['assets']['js'].kind_of?(Array)
        config['assets']['js']
      else
        []
      end
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
  end
end
