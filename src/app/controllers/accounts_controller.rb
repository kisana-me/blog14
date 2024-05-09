class AccountsController < ApplicationController
  before_action :set_account, only: %i[ show ]
  before_action :logged_in_account, only: %i[ logout edit update ]
  before_action :logged_out_account, only: %i[ signup create_signup login create_login ]
  before_action :set_correct_account, only: %i[ edit update ]

  def index
    @accounts = Account.where(
      public: true,
      deleted: false
    ).order(
      id: :desc
    )
  end
  def signup
    @account = Account.new
  end
  def create_signup
    @account = Account.new(account_params)
    @account.aid = generate_aid(Account, 'aid')
    unless @account.invitation_code == ENV['INVITATION_CODE']
      reform()
      @account.errors.add(:invitation_code, '招待コードが有効ではありません')
      flash.now[:danger] = '作成できませんでした'
      render 'signup'
    end
    if @account.save
      redirect_to login_path
      flash[:success] = '作成しました'
    else
      reform()
      flash.now[:danger] = '作成できませんでした'
      render 'signup'
    end
  end
  def login
  end
  def create_login
    @account = Account.find_by(
      name_id: params[:session][:name_id],
      deleted: false
    )
    if @account && @account.authenticate(params[:session][:password])
      log_in(@account)
      flash[:success] = 'ログインしました'
      redirect_to account_path(@account.aid)
    else
      @error_message = 'IDかパスワードが間違っています'
      @reform = {
        name_id: params[:session][:name_id],
        password: params[:session][:password]
      }
      flash.now[:danger] = 'ログインできませんでした'
      render 'login'
    end
  end
  def logout
    log_out()
    flash[:success] = 'ログアウトしました'
    redirect_to root_path
  end
  def show
    unless logged_in?
      @account.update(views_count: @account.views_count + 1)
    end
  end
  def edit
  end
  def update
    if @account.update(update_account_params)
      flash[:success] = '変更しました'
      redirect_to account_path(@account.aid)
    else
      flash.now[:danger] = '変更できませんでした'
      render 'edit'
    end
  end
  def update_password
    # 作成中
  end

  private

  def reform
    @reform = {
      invitation_code: params[:account][:invitation_code],
      password: params[:account][:password],
      password_confirmation: params[:account][:password_confirmation]
    }
  end
  def account_params
    params.require(:account).permit(
      :icon,
      :name,
      :name_id,
      :description,
      :password,
      :password_confirmation,
      :invitation_code,
      :public
    )
  end
  def update_account_params
    params.require(:account).permit(
      :icon,
      :name,
      :name_id,
      :description,
      :public
    )
  end
  def update_password_params
    params.require(:account).permit(
      :password,
      :password_confirmation
    )
  end
  def set_account
    @account = Account.find_by(
      aid: params[:aid],
      public: true,
      deleted: false
    )
    unless @account
      if logged_in?
        return if @account = Account.find_by(aid: params[:aid])
      end
      render_404
    end
  end
  def set_correct_account
    @account = Account.find_by(aid: params[:aid])
    unless @current_account == @account
      render_404
    end
  end
end
