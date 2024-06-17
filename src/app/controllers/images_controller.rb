class ImagesController < ApplicationController
  before_action :logged_in_account
  before_action :set_image, only: %i[ show ]
  before_action :set_correct_image, only: %i[ edit update variants_show variants_create variants_delete image_delete ]

  def index
    all_images = Image.all
    @images = paged_objects(params[:page], all_images, created_at: :desc)
    @images_page = total_page(all_images)
  end
  def show
  end
  def variants_show
  end
  def variants_create
    selected_variant = params[:variant]
    url = ''
    case selected_variant
    when 'images'
      url = @image.image_url(variant_type: 'images')
    when 'tb-images'
      url = @image.image_url(variant_type: 'tb-images')
    end
    flash[:success] = "画像を生成しました#{selected_variant},#{url}"
    redirect_to image_path(@image.aid)
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
  def variants_delete
    if @image.variants_delete
      flash[:success] = 'variantsを削除しました'
      redirect_to image_path(@image.aid)
    else
      flash.now[:danger] = 'variantsの削除ができませんでした'
      render 'show'
    end
  end
  def image_delete
    if @image.image_delete
      flash[:success] = '画像を削除しました'
      redirect_to image_path(@image.aid)
    else
      flash.now[:danger] = '画像の削除ができませんでした'
      render 'show'
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
    @image = Image.find_by(aid: params[:aid], public: true)
  end
  def set_correct_image
    @image = @current_account.images.find_by(
      aid: params[:aid]
    )
    unless @image
      if admin?
        return if @image = Image.find_by(aid: params[:aid])
      end
      render_404
    end
  end
end
