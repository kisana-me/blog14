module ActiveStorage
  class Variant
    attr_reader :blob, :variation

    delegate :service, to: :blob
    delegate :content_type, to: :variation
    def initialize(blob, variation_or_variation_key, custom_key)
      # @blob, @variation = blob, ActiveStorage::Variation.wrap(variation_or_variation_key)
      @blob = blob
      @variation = ActiveStorage::Variation.wrap(variation_or_variation_key)
      @key_suffix = custom_key
    end

    def processed
      process unless processed?
      self
    end

    def key
      "variants/#{blob.key}/#{OpenSSL::Digest::SHA256.hexdigest(variation.key)}"
    end

    def url(expires_in: ActiveStorage.service_urls_expire_in, disposition: :inline)
      service.url key, expires_in: expires_in, disposition: disposition, filename: filename, content_type: content_type
    end

    def download(&)
      service.download(key, &)
    end

    def filename
      ActiveStorage::Filename.new "#{blob.filename.base}.#{variation.format.downcase}"
    end
    alias content_type_for_serving content_type
    def forced_disposition_for_serving # :nodoc:
      nil
    end

    def image
      self
    end

    private

    def processed?
      service.exist?(key)
    end

    def process
      blob.open do |input|
        variation.transform(input) do |output|
          service.upload(key, output, content_type: content_type)
        end
      end
    end
  end
end
