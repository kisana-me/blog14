require "mini_mime"
module ActiveStorage::Blob::Representable
  extend ActiveSupport::Concern
  included do
    has_many :variant_records, class_name: "ActiveStorage::VariantRecord", dependent: false
    before_destroy { variant_records.destroy_all if ActiveStorage.track_variants }

    has_one_attached :preview_image
  end
  def variant(transformations, key)
    if variable?
      variant_class.new(self, ActiveStorage::Variation.wrap(transformations).default_to(default_variant_transformations), key)
    else
      raise ActiveStorage::InvariableError
    end
  end
  def variable?
    ActiveStorage.variable_content_types.include?(content_type)
  end
  def preview(transformations)
    if previewable?
      ActiveStorage::Preview.new(self, transformations)
    else
      raise ActiveStorage::UnpreviewableError
    end
  end
  def previewable?
    ActiveStorage.previewers.any? { |klass| klass.accept?(self) }
  end
  def representation(transformations)
    case
    when previewable?
      preview transformations
    when variable?
      variant transformations
    else
      raise ActiveStorage::UnrepresentableError
    end
  end
  def representable?
    variable? || previewable?
  end
  private
    def default_variant_transformations
      { format: default_variant_format }
    end
    def default_variant_format
      if web_image?
        format || :png
      else
        :png
      end
    end
    def format
      if filename.extension.present? && MiniMime.lookup_by_extension(filename.extension)&.content_type == content_type
        filename.extension
      else
        MiniMime.lookup_by_content_type(content_type)&.extension
      end
    end
    def variant_class
      ActiveStorage.track_variants ? ActiveStorage::VariantWithRecord : ActiveStorage::Variant
    end
end