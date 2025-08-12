require 'fileutils'
require 'json'

class TagsExporter
  def call
    dir = Rails.root.join('storage', 'tags')
    FileUtils.mkdir_p(dir)

    tags_data = Tag.order(:created_at).map do |tag|
      {
        aid: tag.aid,
        name: tag.name,
        description: tag.description,
        public: tag.public,
        views_count: tag.views_count,
        created_at: tag.created_at,
        updated_at: tag.updated_at
      }
    end

    File.write(dir.join('tags.json'), JSON.pretty_generate(tags_data))
    tags_data
  end
end
