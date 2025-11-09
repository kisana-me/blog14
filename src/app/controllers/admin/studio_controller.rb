module Admin
  class StudioController < Admin::ApplicationController
    def index; end

    def export
      AllExporter.new.call
      render plain: "ok"
    end
  end
end
