class Admin::ApplicationController < ApplicationController
  before_action :admin_account
  private
  def admin_account
  end
end