require 'chicanery/bamboo'
require 'chicanery'

module Blinky
  module BambooServer
    include Chicanery

    def watch_bamboo_server name, *args
      server Chicanery::Bamboo.new name, *args

      when_run do |run|
        any_failed = run[:servers][name].any? do |project_name, status|
          status[:last_build_status] == :failure
        end

        any_failed ? failure! : success!
      end

      begin
        run_every 15
      rescue => e
         warning!
         raise e
      end
    end
  end
end
