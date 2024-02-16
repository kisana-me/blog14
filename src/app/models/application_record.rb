class ApplicationRecord < ActiveRecord::Base
  include AccountImages
  primary_abstract_class
  def resize_image(type)
    attachment = image
    attachment.analyze if attachment.attached?
    attachment.variant(image_optimize(type), type).processed
  end
end
