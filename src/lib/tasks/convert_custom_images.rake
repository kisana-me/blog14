namespace :posts do
  desc "Convert custom ?[image](...) embeds in post contents into standard markdown images.
  
  Usage:
    rake posts:convert_custom_images           # dry-run: prints changes
    POST_ID=xxx rake posts:convert_custom_images   # operate only on a single post (id or name_id)
    CONFIRM=1 rake posts:convert_custom_images     # actually save changes
    CONFIRM=1 POST_ID=xxx rake posts:convert_custom_images # save only one post
  "
  task convert_custom_images: :environment do
    require Rails.root.join("lib/md_image_converter")

    confirm = ENV["CONFIRM"].present?
    post_id = ENV["POST_ID"]

    posts = if post_id.present?
              # try numeric id first, then name_id
              found = Post.find_by(id: post_id)
              found ||= Post.find_by(name_id: post_id)
              if found
                # return an ActiveRecord::Relation so we can use find_each below
                Post.where(id: found.id)
              else
                puts "[ImageConverter] No post found for POST_ID=#{post_id}"
                Post.none
              end
            else
              Post.all
            end

    total = 0
    changed = 0

    posts.find_each do |post|
      total += 1
      original = post.content.to_s
      converted = MdImageConverter.convert_custom_images_to_md(original)

      if converted == original
        puts "[ImageConverter] Skip post id=#{post.id} name_id=#{post.name_id} (no changes)"
        next
      end

      changed += 1

      puts "[ImageConverter] Check post id=#{post.id} name_id=#{post.name_id}"

      if confirm
        backup_dir = Rails.root.join("tmp", "post_content_backups")
        FileUtils.mkdir_p(backup_dir)
        backup_file = backup_dir.join("post_#{post.id}_#{Time.now.utc.strftime('%Y%m%d%H%M%S')}.md")
        File.write(backup_file, original)

        # post.update!(content: converted)
        puts "[ImageConverter] Saved post id=#{post.id} name_id=#{post.name_id}"
      else
        puts "[ImageConverter] Not saved. id=#{post.id} name_id=#{post.name_id} Pass CONFIRM=1 to save."
      end
    end

    puts "[ImageConverter] Done. Scanned=#{total}, Changed=#{changed}."
  end
end
