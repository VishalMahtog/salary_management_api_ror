class EmployeeSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :full_name, :job_title, :country, :salary, :role, :designation, :email, :active
end
