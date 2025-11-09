class TagsController < ApplicationController
  include ViewLogger

  before_action :require_admin, except: %i[index show]
  before_action :set_tag, only: %i[show]
  before_action :set_correct_tag, only: %i[edit update destroy]

  def index
    # タグをページングしたい
    @tags = Tag
      .is_normal
      .is_opened
      .limit(10)
  end

  def show
    # 投稿をページングしたい

    unless admin?
      log_view(@tag)
    end

    @posts = @tag.posts
      .from_normal_accounts
      .is_normal
      .isnt_closed
      .order(published_at: :desc)
      .limit(10)
      .includes(:thumbnail)
  end

  def new
    @tag = Tag.new
  end

  def edit; end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      redirect_to tag_path(@tag.name_id), notice: "作成しました"
    else
      flash.now[:alert] = "作成できませんでした"
      render :new
    end
  end

  def update
    if @tag.update(tag_params)
      redirect_to tag_path(@tag.name_id), notice: "更新しました"
    else
      flash.now[:alert] = "更新できませんでした"
      render :edit
    end
  end

  def destroy
    if @tag.update(status: :deleted)
      redirect_to tags_path, notice: "削除しました"
    else
      flash.now[:alert] = "削除できませんでした"
      render :edit
    end
  end

  private

  def tag_params
    params.expect(
      tag: %i[
        name
        name_id
        description
        visibility
      ]
    )
  end

  def set_tag
    return if (@tag = Tag.is_normal.isnt_closed.find_by(name_id: params[:name_id]))
    return if admin? && (@tag = Tag.unscoped.find_by(name_id: params[:name_id]))

    render_404
  end

  def set_correct_tag
    return if admin? && (@tag = Tag.unscoped.find_by(name_id: params[:name_id]))

    render_404
  end
end
