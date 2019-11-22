require 'cgi/util'
require 'logger'
require 'open-uri'
require 'uri'

module AnyDocsTable
  module Scrapers
    class Base
      def initialize(cache_dir:, logger: Logger.new($stderr))
        @cache_dir = cache_dir
        @logger = logger
      end

      private

      def parse_html(html)
        Nokogiri::HTML.parse(html)
      end

      def get_char_count(str)
        str.gsub(/\s+/, '').size
      end

      def get_cached_html(url)
        url = url.to_s

        cache_path = @cache_dir.join("#{CGI.escape(url)}.html")

        if cache_path.exist?
          debug "CACHE: #{url}"
          cache_path.read
        else
          wait
          debug "GET: #{url}"
          html = URI.parse(url).read
          cache_path.parent.mkpath
          cache_path.write(html)
          html
        end
      end

      def wait
        sleep 1
      end

      def debug(obj)
        @logger&.debug(obj)
      end
    end
  end
end
