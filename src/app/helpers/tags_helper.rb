module TagsHelper
  def find_tag(tag_name_id)
    Tag.find_by(
      tag_name_id: tag_name_id,
      deleted: false
    )
  end
  def all_tags
    Tag.where(
      deleted: false
    ).order(
      id: :desc
    )
  end
end