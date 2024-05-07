class Post < ApplicationRecord
  has_many :account_posts
  has_many :accounts, through: :account_posts
  has_many :post_tags
  has_many :tags, through: :post_tags
  has_many :comments
  # Thumbnail
  attr_accessor :thumbnail
  validate :thumbnail_type_and_required
  before_create :thumbnail_upload
  before_update :update_thumbnail_upload
  # Tag
  attr_accessor :tagging_update
  attr_accessor :selected_tags
  after_create :tagging
  after_update :tagging

  # Thumbnail
  def thumbnail_upload
    extension = thumbnail.original_filename.split('.').last.downcase
    key = "/thumbnails/#{self.aid}.#{extension}"
    self.thumbnail_original_key = key
    s3_upload(key: key, file: self.thumbnail.tempfile, content_type: self.thumbnail.content_type)
  end
  def update_thumbnail_upload
    if thumbnail
      if self.thumbnail_original_key.present?
        delete_variants(column_name: 'thumbnail_variants', image_type: 'thumbnails')
        s3_delete(key: self.thumbnail_original_key)
      end
      thumbnail_upload()
    end
  end
  def create_variant(variant_type: 'images')
    process_image(
      variant_type: variant_type,
      image_type: 'thumbnails',
      column_name: 'thumbnail_variants',
      original_key: 'thumbnail_original_key'
    )
  end
  def thumbnail_url(variant_type: 'images')
    if self.thumbnail_original_key.present?
      unless self.thumbnail_variants.include?(variant_type)
        create_variant(variant_type: variant_type)
      end
      return object_url(key: "/variants/#{variant_type}/thumbnails/#{self.aid}.webp")
    else
      return '/'
    end
  end
  def thumbnail?
    thumbnail_original_key.present?
  end
  # Tag
  def tagging
    return unless tagging_update
    if selected_tags.blank?
      self.tags = []
    else
      tmp_tags = []
      selected_tags.each do |aid|
        tag = Tag.find_by(aid: aid)
        tmp_tags << tag
      end
      self.tags = tmp_tags
    end
  end

  private

  def thumbnail_type_and_required
    varidate_image(column_name: 'thumbnail')
  end
end
