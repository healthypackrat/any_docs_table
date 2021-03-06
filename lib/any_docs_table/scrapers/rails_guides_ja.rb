require 'uri'

require 'any_docs_table/scrapers/rails_guides_base'

module AnyDocsTable
  module Scrapers
    class RailsGuidesJa < RailsGuidesBase
      def run
        base_url = URI.parse('https://railsguides.jp/')

        scrape(base_url: base_url)
      end

      EntriesBuilder.register_scraper(:rails_guides_ja, self)
    end
  end
end
