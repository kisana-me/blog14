class Admin::InquiriesController < Admin::ApplicationController
  def index
    @inquiries = Inquiry.all
  end
  def show
    @inquiry = Inquiry.find_by(aid: params[:aid])
  end
  private
end