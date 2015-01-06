# encoding: utf-8
require 'logger'

module Wst
  module Logging
    def logger
      Logging.logger
    end

    def self.logger
      @logger ||= Logger.new(STDOUT)
    end

    def self.logger= logger
      @logger = logger
    end
  end
end
