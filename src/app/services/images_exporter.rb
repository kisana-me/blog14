require 'fileutils'
require 'json'

class ImagesExporter
  def call
    dir = Rails.root.join('storage', 'images')
    FileUtils.mkdir_p(dir)

    images_data = Image.order(:created_at).map do |image|
      {
        aid: image.aid,
        name: image.name,
        description: image.description,
        extension: (e = File.extname(image.original_key.to_s).delete_prefix('.'); e.empty? ? nil : e),
        public: image.public,
        created_at: image.created_at,
        updated_at: image.updated_at
      }
    end

    File.write(dir.join('images.json'), JSON.pretty_generate(images_data))
    images_data
  end
end
