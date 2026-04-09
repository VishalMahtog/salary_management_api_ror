module Hr
  class EmployeesController < Hr::BaseController
    before_action :set_employee, only: %i[show update destroy]
    before_action :set_paginate, only: :index

    def index
      @pagy, @employees = pagy(Employee.all, items: @per_page, page: @page)

      json_response(
        employees: EmployeeSerializer.new(@employees).serializable_hash[:data].pluck(:attributes),
        pagination: paginate_json(@pagy)
      )
    end

    def show
      json_response(employee: EmployeeSerializer.new(@employee).serializable_hash[:data][:attributes])
    end

    def create
      @employee = Employee.new(employee_params)
      if @employee.save
        json_response(EmployeeSerializer.new(@employee).serializable_hash[:data][:attributes], :created)
      else
        json_response({ errors: @employee.errors.full_messages }, :unprocessable_entity)
      end
    end

    def update
      if @employee.update(employee_params)
        json_response(EmployeeSerializer.new(@employee).serializable_hash[:data][:attributes])
      else
        json_response({ errors: @employee.errors.full_messages }, :unprocessable_entity)
      end
    end

    def destroy
      if @employee.destroy
        json_response({ message: "Employee deleted successfully" }, :ok)
      else
        json_response({ errors: @employee.errors.full_messages }, :unprocessable_entity)
      end
    end

    private

    def set_employee
      @employee = Employee.find_by(id: params[:id])

      json_response({ error: "Employee not found" }, :not_found) unless @employee
    end

    def employee_params
      params.require(:employee).permit(
        :full_name, :job_title, :country, :salary, :role, :designation, :email, :password, :password_confirmation, :active
      )
    end
  end
end
