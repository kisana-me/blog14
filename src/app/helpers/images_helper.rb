module ImagesHelper
  def find_image(image_name_id)
    Image.find_by(
      image_name_id: image_name_id,
      public_visibility: true,
      deleted: false
    )
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