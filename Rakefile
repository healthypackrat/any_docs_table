$LOAD_PATH.unshift(File.join(__dir__, 'lib'))

require 'pathname'

require 'any_docs_table'

task :default => :build_html

task :build_html => :build_entries do
  AnyDocsTable::HTMLBuilder.new(
    html_dir: Pathname.new('docs'),
    data_dir: Pathname.new('data'),
    views_dir: Pathname.new('views')
  ).run
end

task :build_entries do
  AnyDocsTable::EntriesBuilder.new(
    data_dir: Pathname.new('data'),
    cache_dir: Pathname.new('tmp/html')
  ).run
end
