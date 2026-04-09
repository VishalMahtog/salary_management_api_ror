module Authentication
  class SessionsController < Devise::SessionsController
    include Response

    respond_to :json

    def new
      json_response({ message: "Unauthorized" }, :unauthorized)
    end

    def create
      self.resource = warden.authenticate(auth_options)

      if resource
        respond_with(resource)
      else
        json_response({ message: "Invalid email or password" }, :unauthorized)
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
        json_response({ message: "Couldn't find an active session" }, :unauthorized)
      end
    end
  end
end
