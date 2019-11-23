require 'uri'

require 'any_docs_table/scrapers/rails_guides_base'

module AnyDocsTable
  module Scrapers
    class RailsGuidesEdge < RailsGuidesBase
      def run
        base_url = URI.parse('https://edgeguides.rubyonrails.org/')

        scrape(base_url: base_url)
      end

      EntriesBuilder.register_scraper(:rails_guides_edge, self)
    end
  end
end
