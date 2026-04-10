class ApplicationController < ActionController::API
  include Pagy::Backend
  include Response
  include ConditionConcern

  private

  def authenticate_employee!
    if current_employee
      unless current_employee.active?
        json_response({ error: "Your account is deactivated. Please contact support." }, :unauthorized)
      end
    else
      json_response({ error: "Please login with valid token" }, :unauthorized)
    end
  end

  def set_paginate
    per_page = params["per_page"].to_i
    @per_page = per_page.positive? && per_page <= MAX_PER_PAGE ? per_page : MIN_PER_PAGE

    page = params["page"].to_i
    @page = page.positive? ? page : MIN_START_PAGE
  end
end
