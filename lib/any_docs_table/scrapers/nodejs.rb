require 'any_docs_table/scrapers/base'

module AnyDocsTable
  module Scrapers
    class NodeJS < Base
      def run
        base_url = 'https://nodejs.org/api/'

        doc = parse_html(get_cached_html(base_url))

        doc.search('#apicontent > ul:nth-child(3) > li > a').map.with_index(1) do |link, index|
          entry = { 'index' => index }

          entry['title'] = link.text.strip

          page_url = base_url + link[:href]

          entry['url'] = page_url

          doc = parse_html(get_cached_html(page_url))

          entry['char_count'] = get_char_count(doc.at('#apicontent').text)

          entry
        end
      end

      EntriesBuilder.register_scraper(:nodejs, self)
    end
  end
end
