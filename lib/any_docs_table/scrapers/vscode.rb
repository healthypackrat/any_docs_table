require 'uri'

module AnyDocsTable
  module Scrapers
    class VSCode < Base
      def run
        base_url = URI.parse('https://code.visualstudio.com/docs')

        doc = parse_html(get_cached_html(base_url))

        entries = []

        index = 1

        doc.search('#main-nav > li').each do |category_node|
          category = category_node.at('./a').text.strip

          category_node.search('./ul/li/a').each do |link|
            entry = { 'category' => category }

            entry['title'] = link.text.strip

            page_url = base_url + link[:href]

            entry['url'] = page_url.to_s

            doc = parse_html(get_cached_html(page_url))

            body = doc.at('.body')

            next unless body

            entry['char_count'] = get_char_count(body.text)

            entry['index'] = index
            index += 1

            entries << entry
          end
        end

        entries
      end

      EntriesBuilder.register_scraper(:vscode, self)
    end
  end
end
