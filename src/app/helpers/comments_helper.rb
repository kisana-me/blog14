module CommentsHelper
  def all_comments
    Comment.where(
      public: true,
      deleted: false
    ).order(
      id: :desc
    )
  end
end
