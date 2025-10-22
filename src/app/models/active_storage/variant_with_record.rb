module ActiveStorage
  class VariantWithRecord
    attr_reader :blob, :variation

    delegate :service, to: :blob
    def initialize(blob, variation, custom_key)
      # @blob, @variation = blob, ActiveStorage::Variation.wrap(variation)
      @blob = blob
      @variation = ActiveStorage::Variation.wrap(variation)
      @key_suffix = custom_key
    end

    def processed
      process
      self
    end

    def process
      transform_blob { |image| create_or_find_record(image: image) } unless processed?
    end

    def processed?
      record.present?
    end

    def image
      record&.image
    end
    delegate :key, :url, :download, to: :image, allow_nil: true

    private

    def transform_blob
      blob.open do |input|
        variation.transform(input) do |output|
          prefix = "variants"
          dir = File.dirname(blob.key)
          if @key_suffix == "icon"
            dir.sub!("images", "icon")
          elsif @key_suffix == "banner"
            dir.sub!("images", "banner")
          end
          name = "#{File.basename(blob.key, '.*')}.#{variation.format.downcase}"
          pre_key = File.join(dir, name)
          key = File.join(prefix, pre_key)

          yield key: key, io: output, filename: "#{blob.filename.base}.#{variation.format.downcase}",
                content_type: variation.content_type, service_name: blob.service.name
        end
      end
    end

    def create_or_find_record(image:)
      @record =
        ActiveRecord::Base.connected_to(role: ActiveRecord.writing_role) do
          blob.variant_records.create_or_find_by!(variation_digest: variation.digest) do |record|
            record.image.attach(image)
          end
        end
    end

    def record
      @record ||= if blob.variant_records.loaded?
                    blob.variant_records.find { |v| v.variation_digest == variation.digest }
                  else
                    blob.variant_records.find_by(variation_digest: variation.digest)
                  end
    end
  end
end
