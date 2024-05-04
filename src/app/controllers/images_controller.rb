class ImagesController < ApplicationController
  before_action :set_image, only: %i[ show edit update ]
  before_action :logged_in_account
  before_action :correct_account, only: %i[ edit update ]
  def index
    @images = Image.all
  end
  def show
  end
  def new
    @image = Image.new
  end
  def create
    @image = Image.new(image_params)
    @image.account = @current_account
    @image.aid = generate_aid(Image, 'aid')
    if @image.save
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
      :image,
      :name,
      :description
    )
  end
  def set_image
    @image = Image.find_by(
      aid: params[:aid],
      deleted: false
    )
  end
  def correct_account
    unless @current_account == Image.find_by(
      aid: params[:aid],
      deleted: false
    ).account
      flash[:danger] = '正しいアカウントではありません'
      redirect_to root_path
    end
  end
end
