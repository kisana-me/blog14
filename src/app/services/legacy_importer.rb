class LegacyImporter
  DEFAULT_DIR = Rails.root.join("storage/exported").freeze

  def initialize(dir: DEFAULT_DIR)
    @base_dir = Pathname.new(dir)
  end

  def import
    raise "Import directory not found: #{@base_dir}" unless @base_dir.directory?

    import_accounts
    import_images
    import_tags
    import_posts
  end

  private

  # ---------- Tags ----------

  def import_tags
    tags_json = @base_dir.join("tags", "tags.json")
    return unless tags_json.file?

    tags = JSON.parse(tags_json.read)
    tags.each do |t|
      import_tag_from_hash(t)
    end
  end

  def import_tag_from_hash(h)
    tag = Tag.new
    tag.aid = h["aid"].to_s[0, 14]
    tag.name = h["name"]
    tag.name_id = h["aid"]
    tag.description = h["description"]
    tag.visibility = :opened if h["public"]
    tag.meta["views_count"] = h["views_count"].present? ? h["views_count"].to_i : 0
    tag.created_at = parse_time(h["created_at"]) if h["created_at"].present?
    tag.updated_at = parse_time(h["updated_at"]) if h["updated_at"].present?
    tag.save!
  rescue StandardError => e
    Rails.logger.warn("[LegacyImporter] Tag(#{h['aid']}) import failed: #{e.message}")
  end

  # ---------- Images ----------

  def import_images
    images_json = @base_dir.join("images", "images.json")
    return unless images_json.file?

    account = Account.find_by(aid: "t1hqj5le60scd7")

    images = JSON.parse(images_json.read)
    images.each do |image|
      import_image_from_hash(image, account)
    end
  end

  def import_image_from_hash(h, account)
    image_path = @base_dir.join("images", "#{h['aid']}.#{h['extension']}")
    raise "Image file not found: #{image_path}" unless image_path.file?

    image = Image.new
    image.account = account
    image.image = build_uploaded_file(image_path)
    image.aid = h["aid"].to_s[0, 14]
    image.name = h["name"]
    image.description = h["description"] + "OLD_AID=#{h['aid']}"
    image.visibility = :opened if h["public"]
    image.created_at = parse_time(h["created_at"]) if h["created_at"].present?
    image.updated_at = parse_time(h["updated_at"]) if h["updated_at"].present?
    image.save!
  rescue StandardError => e
    Rails.logger.warn("[LegacyImporter] Image(#{h['aid']}) import failed: #{e.message}")
  end

  # ---------- Accounts ----------

  def import_accounts
    accounts_index_file = @base_dir.join("accounts", "accounts.json")
    return unless accounts_index_file.file?

    accounts_index_data = JSON.parse(accounts_index_file.read)

    accounts_dir = @base_dir.join("accounts")
    return unless accounts_dir.directory?

    accounts_index_data.each do |acc_aid|
      dir = accounts_dir.join(acc_aid)
      next unless dir.directory?

      json = dir.join("account.json")
      next unless json.file?

      data = JSON.parse(json.read)
      import_account_from_hash(dir, data)
    end
  end

  def import_account_from_hash(dir, h)
    account = Account.new
    account.aid = h["aid"].to_s[0, 14]
    account.name = h["name"]
    account.name_id = h["name_id"]
    account.description = h["description"]
    account.visibility = :opened if h["public"]
    account.meta["views_count"] = h["views_count"].present? ? h["views_count"].to_i : 0
    account.created_at = parse_time(h["created_at"]) if h["created_at"].present?
    account.updated_at = parse_time(h["updated_at"]) if h["updated_at"].present?
    account.save!

    # icon
    icon_path = find_image_by_stem(dir, "icon")
    if icon_path&.file?
      image = create_image_from_file(file_path: icon_path, account: account)
      account.icon = image
      account.save!
    end
  rescue StandardError => e
    Rails.logger.warn("[LegacyImporter] Account(#{h['aid']}) import failed: #{e.message}")
  end

  # ---------- Posts ----------

  def import_posts
    posts_index_file = @base_dir.join("posts", "posts.json")
    return unless posts_index_file.file?

    posts_index_data = JSON.parse(posts_index_file.read)

    posts_dir = @base_dir.join("posts")
    return unless posts_dir.directory?

    posts_index_data.each do |post_aid|
      dir = posts_dir.join(post_aid)
      next unless dir.directory?

      data_path = dir.join("data.json")
      next unless data_path.file?

      data = JSON.parse(data_path.read)
      import_post_from_hash(dir, data)
    end
  end

  def import_post_from_hash(dir, h)
    account = Account.find_by(aid: h["account_aid"].to_s[0, 14])
    unless account
      Rails.logger.warn("[LegacyImporter] Skip Post(#{h['aid']}) because account #{h['account_aid']} not found")
      return
    end

    post = Post.new
    post.account = account
    post.aid = h["aid"].to_s[0, 14]
    post.name_id = h["aid"]
    post.title = h["title"].presence || "Untitled"
    post.summary = h["summary"].presence || "No summary available."
    raw_content = h["content"].presence || "No content available."
    post.content = transform_legacy_images_in_markdown(raw_content)
    post.published_at = parse_time(h["published_at"]) if h["published_at"].present?
    post.edited_at = parse_time(h["edited_at"]) if h["edited_at"].present?
    post.visibility = :opened if h["status"] == "published"
    post.meta["views_count"] = h["views_count"].present? ? h["views_count"].to_i : 0
    post.created_at = parse_time(h["created_at"]) if h["created_at"].present?
    post.updated_at = parse_time(h["updated_at"]) if h["updated_at"].present?
    post.save!

    # Tags by aids
    if h["tags"].is_a?(Array)
      post.tagging(tags: h["tags"].map { |t| t.to_s[0, 14] })
      post.save!
    end

    # Thumbnail
    thumb = find_image_by_stem(dir, "thumbnail")
    if thumb&.file?
      img = create_image_from_file(file_path: thumb, account: account)
      post.thumbnail = img
      post.save!
    end

    # Comments
    comments_path = dir.join("comments.json")
    import_comments_from_json(post, comments_path) if comments_path.file?
  rescue StandardError => e
    Rails.logger.warn("[LegacyImporter] Post(#{h['aid']}) import failed: #{e.message}")
  end

  def import_comments_from_json(post, path)
    arr = JSON.parse(path.read)
    return unless arr.is_a?(Array)

    account_aids = arr.filter_map { |c| c["account_aid"].to_s[0, 14].presence }.uniq
    accounts_by_aid = Account.where(aid: account_aids).index_by(&:aid)

    arr.each do |c|
      c["aid"]
      comment = Comment.new
      comment.post = post
      comment.account = accounts_by_aid[c["account_aid"].to_s[0, 14]] if c["account_aid"].present?
      comment.comment = Comment.find_by(aid: c["parent_comment_aid"].to_s[0, 14]) if c["parent_comment_aid"].present?
      comment.aid = c["aid"].to_s[0, 14]
      comment.name = c["name"]
      comment.content = c["content"]
      comment.address = c["address"]
      comment.created_at = parse_time(c["created_at"]) if c["created_at"].present?
      comment.updated_at = parse_time(c["updated_at"]) if c["updated_at"].present?
      comment.visibility = :opened if c["public"]
      comment.save!
    rescue StandardError => e
      Rails.logger.warn("[LegacyImporter] Comment import failed: #{e.message}")
    end
  end

  # ---------- Helpers ----------

  def parse_time(str)
    return nil if str.blank?

    begin
      Time.zone.parse(str)
    rescue StandardError
      Time.zone.parse(str)
    end
  end

  def create_image_from_file(file_path:, account: nil)
    file = Pathname.new(file_path)
    raise "Image file not found: #{file}" unless file.file?

    Rails.logger.info("[LegacyImporter] Importing image from file: #{file}")
    upload = build_uploaded_file(file)
    Image.create!(account: account, image: upload, visibility: :opened)
  end

  def allowed_image_extensions
    %w[png jpg jpeg webp gif]
  end

  # Finds a file named like "<stem>.<ext>" with a supported image extension (case-insensitive)
  def find_image_by_stem(dir, stem)
    stem_down = "#{stem.downcase}."
    dir.children.each do |p|
      next unless p.file?

      base = p.basename.to_s
      next unless base.downcase.start_with?(stem_down)

      ext = p.extname.delete(".").downcase
      next unless allowed_image_extensions.include?(ext)

      return p
    end
    nil
  end

  def build_uploaded_file(path)
    ext = path.extname.delete(".").downcase
    content_type = mime_type_for(ext)

    tempfile = Tempfile.new(["upload", ".#{ext}"])
    tempfile.binmode
    File.open(path.to_s, "rb") { |f| IO.copy_stream(f, tempfile) }
    tempfile.rewind

    ActionDispatch::Http::UploadedFile.new(
      filename: path.basename.to_s,
      type: content_type,
      tempfile: tempfile
    )
  end

  def mime_type_for(ext)
    case ext
    when "png" then "image/png"
    when "jpg", "jpeg" then "image/jpeg"
    when "webp" then "image/webp"
    when "gif" then "image/gif"
    else "application/octet-stream"
    end
  end

  # Replace legacy Markdown image syntax pointing to m.ivecolor.com with custom image syntax
  # Example:
  #   ![バナー画像](https://m.ivecolor.com/ivecolor/variants/images/images/s6idwa7tmru0j5xey.webp)
  # => ?[image](s6idwa7tmru0j5|バナー画像)
  def transform_legacy_images_in_markdown(text)
    return text if text.blank?

    require "uri"
    domain_prefix = "https://m.ivecolor.com/ivecolor/"

    text.gsub(/!\[(?<alt>[^\]]*)\]\((?<inner>[^)]+)\)/) do |match|
      alt = Regexp.last_match[:alt].to_s.strip
      inner = Regexp.last_match[:inner].to_s.strip

      # Extract URL (ignore optional title following the URL)
      url_part = inner.split(/\s+/, 2).first.to_s
      url = url_part.gsub(/^</, "").gsub(/>$/, "")

      if url.start_with?(domain_prefix)
        begin
          path = URI.parse(url).path.to_s
          filename = File.basename(path).to_s.split("?").first.to_s
          base = filename.sub(/\.[^.]+\z/, "")
          image_id = base[0, 14].to_s
          if image_id.blank?
            match
          else
            alt.present? ? "?[image](#{image_id}|#{alt})" : "?[image](#{image_id})"
          end
        rescue StandardError
          match
        end
      else
        match # keep original
      end
    end
  end
end
