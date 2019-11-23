require 'nokogiri'

require 'any_docs_table/scrapers/base'

module AnyDocsTable
  module Scrapers
    class MongoBase < Base
      private

      def scrape(base_url:, link_selector:, body_selector:)
        doc = parse_html(get_cached_html(base_url))

        doc.search(link_selector).map.with_index(1) do |link, index|
          entry = { 'index' => index }

          entry['title'] = link.text.strip

          page_url = base_url + link[:href]

          entry['url'] = page_url

          doc = parse_html(get_cached_html(page_url))

          entry['char_count'] = get_char_count(doc.at(body_selector).text)

          entry
        end
      end
    end
  end
end
