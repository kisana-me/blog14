namespace :import do
  # 既定の場所 (src/storage/exported) から取り込む
  # bundle exec rake import:legacy
  # # 別ディレクトリを指定して取り込む例
  # bundle exec rake import:legacy["/app/storage/export-dir"]
  desc "Import data from storage/exported (optionally specify DIR)"
  task :legacy, [:dir] => :environment do |_, args|
    dir = args[:dir].presence || Rails.root.join("storage/exported")
    puts "[import:legacy] Importing from: #{dir}"
    LegacyImporter.new(dir: dir).import
    puts "[import:legacy] Done."
  rescue StandardError => e
    puts "[import:legacy] Failed: #{e.class}: #{e.message}"
    raise
  end
end
