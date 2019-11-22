module AnyDocsTable
  module Scrapers
    class MongoRubyDriver < MongoBase
      def run
        base_url = 'https://docs.mongodb.com/ruby-driver/current/'
        link_selector = '#sphinxsidebarwrapper > ul > li > a.internal'
        body_selector = '.body > .section'

        scrape(base_url: base_url, link_selector: link_selector, body_selector: body_selector)
      end

      EntriesBuilder.register_scraper(:mongo_ruby_driver, self)
    end
  end
end
