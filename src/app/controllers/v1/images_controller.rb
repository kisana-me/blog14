class V1::ImagesController < V1::ApplicationController
  include ApplicationHelper
  before_action :api_logged_in_account, only: %i[ create ]
  def create
    @image = Image.new(image_params)
    image_type = content_type_to_extension(params[:image][:image].content_type)
    @image.image.attach(
      key: "accounts/#{@current_account.id}/images/#{@image.image_name_id}.#{image_type}",
      io: (params[:image][:image]),
      filename: "#{@image.image_name_id}.#{image_type}"
    )
    @image.account_id = @current_account.id
    if @image.save
      @image.resize_image('image')
      render json: {status: true, url: full_url("/images/#{@image.image_name_id}.webp")}
    else
      render json: {status: false}
    end
  end
  private
  def image_params
    params.require(:image).permit(
      :name,
      :image_name_id,
      :nsfw,
      :nsfw_message
    )
  end
  def content_type_to_extension(type)
    case type
      when 'image/jpeg' then 'jpg'
      when 'image/png'  then 'png'
      when 'image/gif'  then 'gif'
      when 'image/webp' then 'webp'
    end
  end
end