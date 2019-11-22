require 'uri'

module AnyDocsTable
  module Scrapers
    class TypeScriptHandbook < Base
      def run
        base_url = URI.parse('https://www.typescriptlang.org/docs/home.html')

        doc = parse_html(get_cached_html(base_url))

        entries = []

        index = 1

        doc.search('#toc-handbook, #toc-declaration-files').each do |category_node|
          category = category_node.parent.at('./a').text

          category_node.search('./li/a').each do |link|
            entry = { 'category' => category }

            entry['index'] = index
            index += 1

            entry['title'] = link.text.strip

            page_url = base_url + link[:href]

            entry['url'] = page_url.to_s

            doc = parse_html(get_cached_html(page_url))

            entry['char_count'] = get_char_count(doc.at('article.post-content').text)

            entries << entry
          end
        end

        entries
      end

      EntriesBuilder.register_scraper(:typescript_handbook, self)
    end
  end
end
