require 'erb'
require 'json'

require 'tilt'

module AnyDocsTable
  class HTMLBuilder
    module HTMLHelpers
      include ERB::Util

      def format_number(n)
        n.to_s.gsub(/(?<=\d)(?=(\d{3})+$)/, ',')
      end
    end

    def initialize(html_dir:, data_dir:, views_dir:)
      @html_dir = html_dir
      @data_dir = data_dir
      @views_dir = views_dir
    end

    def run
      links = []

      @data_dir.glob('*.json').sort.each do |entries_path|
        basename = entries_path.basename('.*')

        link = { label: basename, path: "#{basename}.html" }

        links << link

        entries = JSON.parse(entries_path.read)

        tabs = [
          {
            label: 'デフォルト',
            id: 'default',
            active: true,
            entries: entries
          },
          {
            label: '文字数順',
            id: 'sorted',
            active: false,
            entries: entries.sort_by {|entry| [-entry.fetch('char_count'), entry.fetch('title')] }
          }
        ]

        title = link.fetch(:label)

        html = erb('layout.erb', title: title) do
          erb('table.erb', tabs: tabs, title: title)
        end

        output_path = @html_dir.join(link.fetch(:path))
        output_path.parent.mkpath
        output_path.write(html)
      end

      html = erb('layout.erb', title: 'any_docs_table') do
        erb('index.erb', links: links)
      end

      output_path = @html_dir.join('index.html')
      output_path.parent.mkpath
      output_path.write(html)
    end

    private

    def erb(template_path, locals = {}, &block)
      context = Object.new
      context.extend(HTMLHelpers)
      template = Tilt.new(@views_dir.join(template_path), trim: '-')
      template.render(context, locals, &block)
    end
  end
end
