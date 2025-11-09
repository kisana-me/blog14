module CommentsHelper
  def post_public_comments(post)
    post.comments
      .from_normal_accounts
      .isnt_deleted
      .is_opened
      .where(comment_id: nil)
      .order(id: :desc)
  end

  def post_all_comments(post)
    post.comments
      .from_normal_accounts
      .isnt_deleted
      .where(comment_id: nil)
      .order(id: :desc)
  end

  def comment_public_replies(comment)
    comment.comments
      .from_normal_accounts
      .isnt_deleted
      .is_opened
      .order(id: :desc)
  end

  def comment_all_replies(comment)
    comment.comments
      .from_normal_accounts
      .isnt_deleted
      .order(id: :desc)
  end
end
