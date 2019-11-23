require 'any_docs_table/scrapers/base'

module AnyDocsTable
  module Scrapers
    class RailsGuidesBase < Base
      def scrape(base_url:)
        doc = parse_html(get_cached_html(base_url))

        entries = []

        category = nil

        index = 1

        doc.search('#mainCol > h3, #mainCol > dl > dt > a').each do |node|
          case node.name
          when 'h3'
            category = node.text.strip
          when 'a'
            entry = { 'category' => category }

            entry['index'] = index
            index += 1

            entry['title'] = node.text.strip

            page_url = base_url + node[:href]

            entry['url'] = page_url

            doc = parse_html(get_cached_html(page_url))

            entry['char_count'] = get_char_count(doc.at('#mainCol').text)

            entries << entry
          end
        end

        entries
      end
    end
  end
end
