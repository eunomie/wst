# encoding: utf-8
require 'yaml'
require 'wst/configuration'
require 'digest/md5'

module Wst
  class Content
    include Configuration

    def initialize file_path, child = nil
      @file_path = file_path
      @plain_content = ""
      @datas = Hash.new
      @cats = ""
      @child = child
      @content = content

      read_content
    end

    def child
      @child
    end

    def content
      c = self
      while !c.child.nil?
        c = c.child
      end
      c
    end

    def dir
      File.dirname @file_path
    end

    def method_missing(m, *args, &block)
      if m =~ /^(.*)\?$/
        return @datas.has_key? $1
      elsif @datas.has_key? m.to_s
        return @datas[m.to_s]
      else
        return nil
      end
    end

    def raw_content
      @plain_content
    end

    def content_url= url
      @url = url
    end

    def content_url
      @url ||= ''
    end

    def datas
      @datas
    end

    def gravatar?
      email?
    end

    def gravatar
      hash = Digest::MD5.hexdigest(email)
      "http://www.gravatar.com/avatar/#{hash}"
    end

    def account? name
      return false unless config.has_key? "accounts"
      return config["accounts"].has_key? name
    end

    def account name
      return nil unless account? name
      return config["accounts"][name]
    end

    protected

    def default_links_path
      "#{config['path']}/links.md"
    end

    def read_content
      @plain_content = File.open(@file_path, "r:utf-8").read
      begin
        if @plain_content =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
          @plain_content = $'
          @datas = YAML.load $1
        end
      rescue => e
        puts "YAML Exception reading #{@file_path}: #{e.message}"
      end
    end
  end
end
