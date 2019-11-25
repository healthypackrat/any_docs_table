require 'json'

module AnyDocsTable
  class EntriesBuilder
    class << self
      def known_scrapers
        @known_scrapers ||= {}
      end

      def register_scraper(key, klass)
        known_scrapers[key] = klass
      end
    end

    def initialize(data_dir:, cache_dir:)
      @data_dir = data_dir
      @cache_dir = cache_dir
    end

    def run
      self.class.known_scrapers.each do |key, klass|
        output_path = @data_dir.join("#{key}.json")
        next if output_path.exist?
        scraper = klass.new(cache_dir: @cache_dir)
        entries = scraper.run
        output_path.parent.mkpath
        output_path.write(JSON.pretty_generate(entries))
      end
    end
  end
end
