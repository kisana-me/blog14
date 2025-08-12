class Admin::StudioController < Admin::ApplicationController
  def index
  end

  def export
    AllExporter.new.call
    render plain: "ok"
  end
  private
end