require "fileutils"
require "aws-sdk-s3"
require "json"

class AccountExporter
  def initialize(account)
    @account = account
  end

  def call
    dir = Rails.root.join("storage", "accounts", @account.aid)
    FileUtils.mkdir_p(dir)

    report = {
      infos: [],
      errors: [],
      exported_at: Time.current
    }

    # アイコン画像の取得
    if @account.icon_original_key.present?
      ext = File.extname(@account.icon_original_key)
      icon_path = dir.join("icon#{ext}")

      begin
        s3 = Aws::S3::Client.new(
          endpoint: ENV.fetch("S3_LOCAL_ENDPOINT"),
          region: ENV.fetch("S3_REGION"),
          access_key_id: ENV.fetch("S3_USERNAME"),
          secret_access_key: ENV.fetch("S3_PASSWORD"),
          force_path_style: true
        )
        s3.get_object(
          bucket: ENV.fetch("S3_BUCKET"),
          key: @account.icon_original_key.sub(%r{^/}, ""),
          response_target: icon_path.to_s
        )
      rescue StandardError => e
        report[:errors] << "Icon download failed: #{e.message}"
      end
    else
      report[:infos] << "No icon"
    end

    # アカウント情報を JSON に保存
    account_data = {
      aid: @account.aid,
      name: @account.name,
      name_id: @account.name_id,
      description: @account.description,
      public: @account.public,
      views_count: @account.views_count,
      created_at: @account.created_at,
      updated_at: @account.updated_at
    }
    File.write(dir.join("account.json"), JSON.pretty_generate(account_data))

    File.write(dir.join("report.json"), JSON.pretty_generate(report))
    account_data
  end
end
