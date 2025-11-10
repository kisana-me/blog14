# frozen_string_literal: true

# Utility to convert custom image embed syntax to standard markdown image syntax.
# FROM custom syntax:   `?[image](aid|caption, aid2|caption2)`
# INTO standard syntax: `![alt](url)`

module MdImageConverter
  module_function

  def convert_custom_images_to_md(text)
    return text if text.nil? || text.empty?

    text.to_s.gsub(/\?\[image\]\(([^)]+)\)/) do
      raw = Regexp.last_match(1).to_s
      items = raw.split(",").map(&:strip).reject(&:empty?)
      aids = items.map { |it| it.split("|", 2).first.to_s.strip }

      images = Image.from_normal_accounts.is_normal.where(aid: aids).index_by(&:aid)

      md_images = items.map do |item|
        aid, caption = item.split("|", 2).map { |s| s.to_s.strip }
        image = images[aid]

        if image
          url = image.image_url(variant_type: "normal")
          alt = if caption && !caption.empty?
                  caption
                else
                  image.name.to_s
                end
          "![#{alt}](#{url})"
        else
          "[missing image: #{aid}]"
        end
      end

      md_images.join("\n\n")
    end
  end
end
