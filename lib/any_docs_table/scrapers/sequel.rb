require 'any_docs_table/scrapers/base'

module AnyDocsTable
  module Scrapers
    class Sequel < Base
      def run
        base_url = 'http://sequel.jeremyevans.net/'

        doc = parse_html(get_cached_html(base_url + 'documentation.html'))

        entries = []

        index = 1

        doc.search('#content > ul:nth-child(4) > li').each do |category_node|
          category = category_node.children.first

          category_node.search('ul > li > a').each do |link|
            entry = { 'category' => category }

            entry['index'] = index
            index += 1

            entry['title'] = link.text.strip

            page_url = base_url + link[:href]

            entry['url'] = page_url.to_s

            doc = parse_html(get_cached_html(page_url))

            entry['char_count'] = get_char_count(doc.at('#description').text)

            entries << entry
          end
        end

        entries
      end

      EntriesBuilder.register_scraper(:sequel, self)
    end
  end
end
