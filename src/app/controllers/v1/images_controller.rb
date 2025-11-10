module V1
  class ImagesController < V1::ApplicationController
    before_action :api_require_signin

    def create
      @image = Image.new(image_params)
      @image.account = @current_account
      if @image.save
        render json: {
          flag: true,
          url: @image.image_url,
          aid: @image.aid,
          name: @image.name
        }
      else
        render json: {
          flag: false
        }
      end
    end

    private

    def image_params
      params.expect(
        image: %i[
          image
          name
          description
          visibility
        ]
      )
    end
  end
end
