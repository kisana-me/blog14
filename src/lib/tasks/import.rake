namespace :legacy do
  desc "Import data from storage/ivecolor-exported (optionally specify DIR)"
  task :import, [:dir] => :environment do |_, args|
    dir = args[:dir].presence || Rails.root.join('storage', 'ivecolor-exported')
    puts "[legacy:import] Importing from: #{dir}"
    LegacyImporter.new(dir: dir).import
    puts "[legacy:import] Done."
  rescue => e
    puts "[legacy:import] Failed: #{e.class}: #{e.message}"
    raise
  end
end
