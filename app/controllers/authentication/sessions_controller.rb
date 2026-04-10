module Authentication
  class SessionsController < Devise::SessionsController
    include Response

    respond_to :json

    def new
      json_response({ error: "Unauthorized" }, :unauthorized)
    end

    def create
      self.resource = Employee.authenticate(params[:email], params[:password])

      if resource
        sign_in(resource)
        respond_with(resource)
      else
        json_response({ error: "Invalid email or password, or your account is not confirmed or has been deactivated." }, :unauthorized)
      end
    end

    private

    def respond_with(resource, _opts = {})
      token = request.env["warden-jwt_auth.token"]

      json_response({
        message: "Logged in successfully",
        token: token,
        data: EmployeeSerializer.new(resource).serializable_hash[:data][:attributes]
      }, :ok)
    end

    def respond_to_on_destroy(_resource = nil)
      if current_employee
        json_response({ message: "Logged out successfully" }, :ok)
      else
        json_response({ error: "Couldn't find an active session" }, :unauthorized)
      end
    end
  end
end
