module Hr
  class BaseController < ApplicationController
    before_action :authenticate_employee!
    before_action :ensure_hr!

    private

    def ensure_hr!
      return if current_employee.hr?

      json_response({ error: "Forbidden" }, :forbidden)
    end
  end
end
