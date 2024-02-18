class TagsController < ApplicationController
  include TagsHelper
  before_action :set_tag, only: %i[ show edit update ]
  before_action :logged_in_account, only: %i[ new create edit update ]
  def index
    @tags = all_tags
  end
  def show
  end
  def new
    @tag = Tag.new
  end
  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      flash[:success] = '作成しました'
      redirect_to tag_path(@tag.tag_name_id)
    else
      flash.now[:danger] = '作成できませんでした'
      render 'new'
    end
  end
  def edit
  end
  def update
    if @tag.update(tag_params)
      flash[:success] = '編集しました'
      redirect_to post_path(@tag.tag_name_id)
    else
      flash.now[:danger] = '編集できませんでした'
      render 'new'
    end
  end

  private

  def tag_params
    params.require(:tag).permit(
      :tag_name_id,
      :name,
      :description
    )
  end
  def set_tag
    @tag = find_tag(params[:tag_name_id])
  end  
end
