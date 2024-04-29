module AccountsHelper
  def find_account(aid)
    Account.find_by(
      aid: aid,
      deleted: false
    )
  end
  def all_accounts
    Account.where(
      deleted: false
    ).order(
      id: :desc
    )
  end
end
