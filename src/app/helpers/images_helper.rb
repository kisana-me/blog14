module ImagesHelper
  def image_url(variant_type: 'images', image_type: 'images', aid: '', format: 'webp')
    return object_url(key: "variants/#{variant_type}/#{image_type}/#{aid}.#{format}")
  end
  def original_image_url(image_type: 'images', aid: '', format: 'webp')
    return signed_object_url(key: "#{image_type}/#{aid}.#{format}")
  end
  def all_images
    Image.where(
      public_visibility: true,
      deleted: false
    ).order(
      id: :desc
    )
  end
end