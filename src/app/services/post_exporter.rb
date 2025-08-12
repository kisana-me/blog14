require 'fileutils'
require 'open-uri'
require 'aws-sdk-s3'
require 'json'

class PostExporter
  def initialize(post)
    @post = post
    @markdown_text = post.content
  end

  def call
    dir = Rails.root.join('storage', 'posts', @post.aid)
    FileUtils.mkdir_p(dir)
    FileUtils.mkdir_p(dir.join('images'))

    pattern = /!\[(.*?)\]\((https?:\/\/[^)]+\/([^.\/]+)\.webp)\)/
    report = {
      infos: [],
      errors: [],
      not_found_images: [],
      exported_at: Time.current
    }

    # サムネイル取得
    if @post.thumbnail_original_key.present?
      ext = File.extname(@post.thumbnail_original_key)
      image_path = dir.join("thumbnail#{ext}")

      begin
      s3 = Aws::S3::Client.new(
        endpoint: ENV.fetch("S3_LOCAL_ENDPOINT"),
        region: ENV.fetch("S3_REGION"),
        access_key_id: ENV.fetch("S3_USERNAME"),
        secret_access_key: ENV.fetch("S3_PASSWORD"),
        force_path_style: true
      )
      s3.get_object(
        bucket: ENV.fetch("S3_BUCKET"),
        key: @post.thumbnail_original_key.sub(%r{^/}, ''),
        response_target: image_path.to_s
      )
      rescue => e
        report[:errors] << "Thumbnail download failed: #{e.message}"
      end
    else
      report[:infos] << "No thumbnail"
    end

    # マークダウン取得
    converted_text = @markdown_text.gsub(pattern) do
      alt_text = Regexp.last_match(1)
      image_url = Regexp.last_match(2)
      image_aid  = Regexp.last_match(3)
      if image = Image.find_by(aid: image_aid)
        ext = File.extname(image.original_key)
        image_path = dir.join('images', image_aid + ext)
        s3 = Aws::S3::Client.new(
          endpoint: ENV.fetch("S3_LOCAL_ENDPOINT"),
          region: ENV.fetch("S3_REGION"),
          access_key_id: ENV.fetch("S3_USERNAME"),
          secret_access_key: ENV.fetch("S3_PASSWORD"),
          force_path_style: true
        )
        s3.get_object(
          bucket: ENV.fetch("S3_BUCKET"),
          key: image.original_key.sub(%r{^/}, ''),
          response_target: image_path.to_s
        )
      else
        Rails.logger.warn "Image with aid=#{image_aid} not found"
        report[:not_found_images] << image_aid
      end
      "![#{alt_text}](:image_aid:#{image_aid})"
    end
    File.write(dir.join('report.json'), JSON.pretty_generate(report))
    File.write(dir.join('post.md'), converted_text)

    # コメント取得
    comments_data = @post.comments.order(:created_at).map do |c|
      {
        aid: c.aid,
        account_aid: c.account&.aid,
        name: c.name,
        content: c.content,
        address: c.address,
        public: c.public,
        created_at: c.created_at,
        updated_at: c.updated_at,
        parent_comment_aid: c.comment_id ? Comment.find_by(id: c.comment_id)&.aid : nil
      }
    end
    File.write(dir.join('comments.json'), JSON.pretty_generate(comments_data))

    # その他データ取得
    post_data = {
      account_aid: @post.account.aid,
      aid: @post.aid,
      title: @post.title,
      summary: @post.summary,
      content: @post.content,
      views_count: @post.views_count,
      status: @post.status,
      published_at: @post.published_at,
      edited_at: @post.edited_at,
      created_at: @post.created_at,
      updated_at: @post.updated_at,
      tags: @post.tags.pluck(:aid)
    }
    File.write(dir.join('data.json'), JSON.pretty_generate(post_data))

    File.write(dir.join('report.json'), JSON.pretty_generate(report))
    converted_text
  end
end
