# encoding: utf-8
require 'wst/md_content'

module Wst
  class Post < MdContent
    @@glob = "*.{md,mkd,markdown}"

    def initialize file_path
      super file_path

      base_path = File.join(Configuration.config['path'], '_posts') + '/'
      @cats = @cats.gsub(base_path, '') if !@cats.nil?
      @cats.chomp!('/')
    end

    def content_url
      generate_url = {
        "year"  => @date.strftime("%Y"),
        "month" => @date.strftime("%m"),
        "day"   => @date.strftime("%d"),
        "title" => CGI.escape(@slug)
      }.inject(":year/:month/:day/:title.html") { |result, token|
        result.gsub(/:#{Regexp.escape token.first}/, token.last)
      }.gsub(/\/\//, "/")
      generate_url = "#{@cats}/#{generate_url}" if @cats != ''
      generate_url
    end

    class << self
      def all
        post_files.inject([]) { |posts, file| posts << Post.new(file) }
      end

      private

      def glob_path
        File.join "#{Configuration.config['path']}/_posts", '**', @@glob
      end

      def all_files
        Dir.glob glob_path
      end

      def select_match files
        files.select { |file| file =~ @@matcher }
      end

      def post_files
        select_match(all_files).sort
      end
    end
  end
end
