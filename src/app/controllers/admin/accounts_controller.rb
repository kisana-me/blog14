module Admin
  class AccountsController < Admin::ApplicationController
    before_action :set_account, only: %i[edit update]

    def index
      @accounts = Account.all
    end

    def edit; end

    def update
      if @account.update(account_params)
        flash[:notice] = "変更しました"
        redirect_to admin_account_path(@account.aid)
      else
        flash.now[:alert] = "変更できませんでした"
        render "edit"
      end
    end

    private

    def set_account
      @account = Account.find_by(aid: params[:aid])
    end

    def account_params
      params.expect(
        account: %i[aid
                    icon
                    name
                    icon_original_key
                    icon_variants
                    name_id
                    description
                    public
                    description
                    likes_count
                    views_count
                    posts_count
                    settings
                    metadata
                    roles
                    password_digest
                    password
                    password_confirmation
                    deleted
                    created_at
                    updated_at]
      )
    end
  end
end
