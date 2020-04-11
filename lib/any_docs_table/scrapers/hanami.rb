require 'any_docs_table/scrapers/base'

module AnyDocsTable
  module Scrapers
    class Hanami < Base
      def run
        base_url = 'https://guides.hanamirb.org'

        doc = parse_html(get_cached_html(base_url + '/introduction/getting-started/'))

        entries = []

        index = 1

        doc.search('#ct-docs-nav .ct-toc-link').each do |category_node|
          category = category_node.text.strip

          links = category_node.next_element.search('a')

          links.each do |link|
            entry = { 'category' => category }

            entry['index'] = index
            index += 1

            entry['title'] = link.text.strip

            page_url = base_url + link[:href]

            entry['url'] = page_url

            doc = parse_html(get_cached_html(page_url))

            entry['char_count'] = get_char_count(doc.at('main').text)

            entries << entry
          end
        end

        entries
      end

      EntriesBuilder.register_scraper(:hanami, self)
    end
  end
end
