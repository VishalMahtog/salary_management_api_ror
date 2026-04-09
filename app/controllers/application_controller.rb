class ApplicationController < ActionController::API
  include Response


  private

  def authenticate_employee!
    unless current_employee
      json_response( { error: 'Please login with valid token' }, :unauthorized)
    end
  end
end
