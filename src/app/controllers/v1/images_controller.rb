module V1
  class ImagesController < V1::ApplicationController
    before_action :api_logged_in_account
    def create
      @image = Image.new(image_params)
      @image.account = @current_account
      @image.aid = generate_aid(Image, "aid")
      if @image.save
        render json: { status: true, url: Image.find_by(aid: @image.aid).image_url }
      else
        render json: { status: false }
      end
    end

    private

    def image_params
      params.expect(
        image: %i[image
                  name
                  description]
      )
    end
  end
end
