module Admin
  class StudioController < Admin::ApplicationController
    def index; end

    def console; end

    def post_console
      case params[:command].to_s
      when "recommended_posts_cache_clear"
        Rails.cache.delete('recommended_posts')
        flash.now[:notice] = "Recommended posts cache cleared."
        render :console
      when "all_cache_clear"
        Rails.cache.clear
        flash.now[:notice] = "All cache cleared."
        render :console
      else
        flash.now[:alert] = "Invalid command."
        render :console
      end
    end
  end
end
