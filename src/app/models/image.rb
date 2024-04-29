class Image < ApplicationRecord
  belongs_to :account
  validate :image_type
  before_create :image_upload
  attr_accessor :image
  
  def image_upload
    extension = image.original_filename.split('.').last.downcase
    key = "/images/#{self.aid}.#{extension}"
    self.original_key = key
    s3_upload(key: key, file: self.image.tempfile, content_type: self.image.content_type)
  end

  def image_variant_destroy
    # aaa
  end

  def image_destroy
    # aaa
  end

  private
  def image_type
    if image
      allowed_content_types = ['image/png', 'image/jpeg', 'image/gif', 'image/webp']
      unless allowed_content_types.include?(image.content_type)
        errors.add(:image, "未対応の形式です")
      end
    elsif new_record?
      errors.add(:image, "画像がありません")
    end
  end
end
