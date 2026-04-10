class Employee < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  validates :full_name, :job_title, :country, :salary, :role, :designation, presence: true

  enum :role, { employee: 0, hr: 1 }

  scope :active, -> { where(active: true) }

  def self.authenticate(email, password)
    employee = Employee.active.find_for_authentication(email: email)
    return unless employee&.valid_password?(password) && employee.confirmed?

    employee
  end
end
