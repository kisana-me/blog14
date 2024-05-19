class Post < ApplicationRecord
  belongs_to :account
  has_many :post_tags
  has_many :tags, through: :post_tags
  has_many :comments
  # Thumbnail
  attr_accessor :thumbnail
  validate :thumbnail_type_and_required
  before_create :thumbnail_upload
  before_update :thumbnail_upload
  # Tag
  # taggingメソッドで代入
  attr_accessor :selected_tags

  # Thumbnail
  def thumbnail_upload
    if thumbnail
      if self.thumbnail_original_key.present?
        delete_variants(variants_column: 'thumbnail_variants', image_type: 'thumbnails')
        s3_delete(key: self.thumbnail_original_key)
      end
        extension = thumbnail.original_filename.split('.').last.downcase
        key = "/thumbnails/#{self.aid}.#{extension}"
        self.thumbnail_original_key = key
        s3_upload(key: key, file: self.thumbnail.tempfile, content_type: self.thumbnail.content_type)
    end
  end
  def thumbnail_url(variant_type: 'images')
    if self.thumbnail_original_key.present?
      unless self.thumbnail_variants.include?(variant_type)
        process_image(
          variant_type: variant_type,
          image_type: 'thumbnails',
          variants_column: 'thumbnail_variants',
          original_key_column: 'thumbnail_original_key'
        )
      end
      return object_url(key: "/variants/#{variant_type}/thumbnails/#{self.aid}.webp")
    else
      return nil
    end
  end
  def thumbnail_variants_delete
    delete_variants(variants_column: 'thumbnail_variants', image_type: 'thumbnails')
    self.save
  end
  def thumbnail?
    thumbnail_original_key.present?
  end
  # Tag
  def tagging(arr: selected_tags)
    if arr.blank?
      self.tags = []
    else
      tmp_tags = []
      arr.each do |aid|
        tag = Tag.find_by(aid: aid)
        tmp_tags << tag
      end
      self.tags = tmp_tags
    end
  end

  private

  def thumbnail_type_and_required
    varidate_image(column_name: 'thumbnail', required: false)
  end
end
