class Admin::StudioController < Admin::ApplicationController
  before_action :api_logged_in_account, only: %i[ create ]
  def index
  end
  def create
  end
  private
  def image_params
  end
end