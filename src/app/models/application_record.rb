class ApplicationRecord < ActiveRecord::Base
  include AccountImages
  BASE_64_URL_REGEX  = /\A[a-zA-Z0-9_-]*\z/
  primary_abstract_class
  def resize_image(type)
    attachment = image
    attachment.analyze if attachment.attached?
    attachment.variant(image_optimize(type), type).processed
  end
end
