module ImageTools
  def process_image(variant_type: 'images', image_type: 'images')
    variants =JSON.parse(self.variants)
    if variants.include?(image_type)
      return
    end
    s3 = Aws::S3::Client.new(
      endpoint: ENV["S3_LOCAL_ENDPOINT"],
      region: ENV["S3_REGION"],
      access_key_id: ENV["S3_USER"],
      secret_access_key: ENV["S3_PASSWORD"],
      force_path_style: true
    )
    downloaded_image = Tempfile.new(['downloaded_image'])
    converted_image = Tempfile.new(['converted_image'])
    s3.get_object(bucket: ENV["S3_BUCKET"], key: self.original_key, response_target: downloaded_image.path)
    image = MiniMagick::Image.open(downloaded_image.path)
    resize = "2048x2048>"
    extent = "" # 切り取る
    case variant_type
    # icon
    when 'icons'
      resize = "400x400^"
      extent = "400x400"
    when 'tb-icons'
      resize = "50x50^"
      extent = "50x50"
    # banner
    when 'banners'
      resize = "1600x1600^"
      extent = "1600x1600"
    when 'tb-banners'
      resize = "400x400^"
      extent = "400x400"
    # image
    when 'images'
      resize = "2048x2048>"
    when 'tb-images'
      resize = "700x700>"
    when '4k-images'
      resize = "4096x4096>"
    # emoji
    when 'emojis'
      resize = "200x200>"
    when 'tb-emojis'
      resize = "50x50>"
    end
    image.format('webp')
    image.coalesce
    image.combine_options do |img|
      img.gravity "center"
      img.quality 85
      img.auto_orient
      img.strip # EXIF削除
      img.resize resize
      unless extent == ''
        img.extent extent
      end
    end
    image.write(converted_image.path)
    key = "/variants/#{variant_type}/#{image_type}/#{self.aid}.webp"
    s3_upload(key: key, file: converted_image.path, content_type: 'image/webp')
    add_mca_data(self, 'variants', [image_type])
    downloaded_image.close
    converted_image.close
  end
end