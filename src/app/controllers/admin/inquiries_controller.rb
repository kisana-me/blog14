class Admin::InquiriesController < Admin::ApplicationController
  def index
    @inquiries = Inquiry.order(created_at: :DESC)
  end
  def show
    @inquiry = Inquiry.find_by(aid: params[:aid])
  end
  def update
    @inquiry = Inquiry.find_by(aid: params[:aid])
    if @inquiry.update(inquiry_params)
      flash[:success] = '変更しました'
      redirect_to admin_inquiry_path(@inquiry.aid)
    else
      flash.now[:danger] = '変更できませんでした'
      render 'show'
    end
  end
  private
  def inquiry_params
    params.require(:inquiry).permit(
      :memo,
      :done
    )
  end
end