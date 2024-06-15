class Image < ApplicationRecord
  belongs_to :account
  validate :image_type_and_required
  before_create :image_upload
  before_update :image_upload
  attr_accessor :image

  def image_upload
    if image
      if self.original_key.present?
        delete_variants()
        s3_delete(key: self.original_key)
      end
        extension = image.original_filename.split('.').last.downcase
        key = "/images/#{self.aid}.#{extension}"
        self.original_key = key
        s3_upload(key: key, file: self.image.path, content_type: self.image.content_type)
    end
  end
  def image_url(variant_type: 'images')
    if self.original_key.present?
      unless self.variants.include?(variant_type)
        process_image(variant_type: variant_type)
      end
      return object_url(key: "/variants/#{variant_type}/images/#{self.aid}.webp")
    else
      return '/'
    end
  end
  def variants_delete
    delete_variants()
    self.save
  end
  def image_delete
    delete_image()
    self.save
  end

  private

  def image_type_and_required
    varidate_image()
  end
end
