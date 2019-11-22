module AnyDocsTable
  module Scrapers
    class Mongoid < MongoBase
      def run
        base_url = 'https://docs.mongodb.com/mongoid/current/'
        link_selector = '#sphinxsidebarwrapper > ul > li > a.internal'
        body_selector = '.body > .section'

        scrape(base_url: base_url, link_selector: link_selector, body_selector: body_selector)
      end

      EntriesBuilder.register_scraper(:mongoid, self)
    end
  end
end
