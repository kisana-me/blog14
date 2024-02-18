class AccountsController < ApplicationController
  before_action :set_account, only: %i[ show edit update ]
  before_action :logged_in_account, only: %i[ logout edit update ]
  before_action :logged_out_account, only: %i[ signup create_signup login create_login ]
  before_action :admin_account, only: %i[  ]
  before_action :correct_account, only: %i[ edit update ]
  def index
    @accounts = all_accounts
  end
  def signup
    @account = Account.new
  end
  def create_signup
    @account = Account.new(account_params)
    @account.account_id = unique_random_id(Account, 'account_id')
    if params[:account][:invitation_code] == ENV['INVITATION_CODE']
      if @account.save
        redirect_to login_path
        flash[:success] = '作成しました'
      else
        @reform = {
          invitation_code: params[:account][:invitation_code],
          password: params[:account][:password],
          password_confirmation: params[:account][:password_confirmation]
        }
        flash.now[:danger] = '作成できませんでした'
        render 'signup'
      end
    else
      @reform = {
        invitation_code: params[:account][:invitation_code],
        password: params[:account][:password],
        password_confirmation: params[:account][:password_confirmation]
      }
      @account.errors.add(:base, '招待コードが違います')
      flash.now[:danger] = '作成できませんでした'
      render 'signup'
    end
  end
  def login
  end
  def create_login
    @account = find_account(params[:session][:name_id])
    if @account && @account.authenticate(params[:session][:password])
      log_in(@account)
      flash[:success] = 'ログインしました'
      redirect_to account_path(@account.name_id)
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
    log_out
    flash[:success] = 'ログアウトしました'
    redirect_to root_path
  end
  def show
  end
  def edit
  end
  def update
    if @account.update(update_account_params)
      flash[:success] = '変更しました'
      redirect_to account_path(@account.name_id)
    else
      flash.now[:danger] = '変更できませんでした'
      render 'edit'
    end
  end

  private

  def account_params
    params.require(:account).permit(
      :name,
      :name_id,
      :bio,
      :password,
      :password_confirmation
    )
  end
  def update_account_params
    params.require(:account).permit(
      :name,
      :name_id,
      :bio
    )
  end
  def set_account
    @account = find_account(params[:name_id])
  end
  def correct_account
    unless @current_account == find_account(params[:name_id])
      flash[:danger] = '正しいアカウントではありません'
      redirect_to root_path
    end
  end
end
