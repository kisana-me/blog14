module MdTools

  def custom2standard_image(content)
    return if content.blank?

    content
  end

  def standard2custom_image(content)
    return if content.blank?

    require "uri"
    domain_prefix = "https://m.ivecolor.com/ivecolor/"
    domain_prefix2 = "http://localhost:9000/ivecolor/"

    new_content = content.gsub(/!\[(?<alt>[^\]]*)\]\((?<inner>[^)]+)\)/) do |match|
      alt = Regexp.last_match[:alt].to_s.strip
      inner = Regexp.last_match[:inner].to_s.strip

      url_part = inner.split(/\s+/, 2).first.to_s
      url = url_part.gsub(/^</, "").gsub(/>$/, "")

      if url.start_with?(domain_prefix) || url.start_with?(domain_prefix2)
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

    new_content
  end
end
