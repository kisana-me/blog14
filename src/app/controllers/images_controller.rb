class ImagesController < ApplicationController
  before_action :logged_in_account
  before_action :set_image, only: %i[ show ]
  before_action :set_correct_image, only: %i[ edit update ]

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
      :description,
      :public
    )
  end
  def set_image
    @image = Image.find_by(aid: params[:aid])
  end
  def set_correct_image
    unless @current_account == Image.find_by(aid: params[:aid]).account
      render_404
    end
  end
end
