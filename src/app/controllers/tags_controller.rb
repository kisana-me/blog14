class TagsController < ApplicationController
  before_action :logged_in_account, only: %i[ new create edit update ]
  before_action :set_tag, only: %i[ show ]
  before_action :set_correct_tag, only: %i[ edit update ]
  def index
    @tags = Tag.where(
      deleted: false
    ).order(
      id: :desc
    )
  end
  def show
    unless logged_in?
      @tag.update(views_count: @tag.views_count += 1)
    end
  end
  def new
    @tag = Tag.new
  end
  def create
    @tag = Tag.new(tag_params)
    @tag.aid = generate_aid(Tag, 'aid')
    if @tag.save
      flash[:success] = '作成しました'
      redirect_to tag_path(@tag.aid)
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
      redirect_to tag_path(@tag.aid)
    else
      flash.now[:danger] = '編集できませんでした'
      render 'new'
    end
  end

  private

  def tag_params
    params.require(:tag).permit(
      :name,
      :description
    )
  end
  def set_tag
    @tag = Tag.find_by(
      aid: params[:aid],
      deleted: false
    )
    unless @tag
      if logged_in?
        return if @tag = Tag.find_by(aid: params[:aid])
      end
      return render_404
    end
  end
  def set_correct_tag
    render_404 unless @tag = Tag.find_by(aid: params[:aid])
  end
end
