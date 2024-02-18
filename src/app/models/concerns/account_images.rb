module AccountImages
  def image_optimize(type)
    resize = "2048x2048>"
    extent = ""
    if type == 'icon'
      resize = "500x500^"
      extent = "500x500"
    elsif type == 'banner'
      resize = "2000x2000^"
      extent = "2000x2000"
    elsif type == 'image'
      resize = "2048x2048>"
    end
    resized = start_optimize.merge(
      resize: resize,
      extent: extent
    )
    #resized.merge(end_optimize)
  end
  private
  def start_optimize
    {
      coalesce: true, # アニメーションシーケンスの最適化
      gravity: "center",
      loader: { page: nil },
      # dither: true, #'+': true, # エイリアシングを無効化して処理を早くする(動かない)
      # layers: 'Optimize', # GIFアニメーションを最適化
      quality: '85',
      format: "webp",
      auto_orient: true,
      strip: true,
    }
  end
  def end_optimize
    {
      gravity: "south",
      background: "black",
      fill: "white",
      font: font,
      splice: "0x24",
      pointsize: "14",
      draw: "gravity southeast text 10,2 'Posted to #{ENV["APP_NAME"]}' ",
      deconstruct: true # アニメーションシーケンスの最適化2 #動くwebpで2回目処理時に文字が消えるバグ対策
    }
  end
  def font
    './app/assets/fonts/???'
  end
end