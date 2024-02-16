class ImagesController < ApplicationController
  include Images
  include ImagesHelper
  before_action :set_image, only: %i[ show edit update ]
  before_action :logged_in_account, only: %i[ new create edit update ]
  before_action :correct_account, only: %i[ edit update ]
  def index
    @images = all_images
  end
  def show
    Rails.logger.info(@image)
    send_noblob_stream(
      @image.image, @image.resize_image('image')
    )
  end
  def new
    @image = Image.new
  end
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
      flash[:success] = "画像をアップロードしました"
      redirect_to images_path
    else
      flash.now[:danger] = "画像をアップロードできませんでした"
      render 'new'
    end
  end
  def edit
  end
  def update
    Rails.logger.info(@image.id)
    if @image.update(image_params)
      flash[:success] = '変更しました'
      redirect_to images_path
    else
      flash.now[:danger] = '変更できませんでした'
      render 'edit'
    end
  end
  private
  def image_params
    params.require(:image).permit(
      :name,
      :image_name_id,
      :nsfw,
      :nsfw_message,
      :public_visibility
    )
  end
  def set_image
    @image = find_image(params[:image_name_id])
  end
  def content_type_to_extension(type)
    case type
      when 'image/jpeg' then 'jpg'
      when 'image/png'  then 'png'
      when 'image/gif'  then 'gif'
      when 'image/webp' then 'webp'
    end
  end
  def correct_account
    unless @current_account == find_image(params[:image_name_id]).account
      flash[:danger] = '正しいアカウントではありません'
      redirect_to root_path
    end
  end
end
