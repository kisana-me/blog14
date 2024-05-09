module CommentsHelper
  def all_comments
    Comment.where(
      public: true,
      deleted: false
    ).order(
      id: :desc
    )
  end
  def post_comments(post)
    post.comments.where(
      comment_id: nil,
      public: true,
      deleted: false
    ).order(
      id: :desc
    )
  end
  def post_all_comments(post)
    post.comments.where(
      comment_id: nil
    ).order(
      id: :desc
    )
  end
  def comment_replies(comment)
    comment.comments.where(
      public: true,
      deleted: false
    ).order(
      id: :desc
    )
  end
  def comment_all_replies(comment)
    comment.comments.order(
      id: :desc
    )
  end
end
