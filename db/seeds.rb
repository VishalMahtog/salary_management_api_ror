require 'faker'
require 'securerandom'

employees = []

designations = [
  "Software Engineer",
  "Project Manager",
  "HR Executive",
  "Marketing Specialist",
  "Senior Accountant"
]

total = 10_000
batch_size = 1000

total.times do |i|
  employees << {
    full_name: Faker::Name.name,
    job_title: Faker::Job.title,
    country: Faker::Address.country,
    salary: rand(30_000..150_000),
    role: [ 0, 1 ].sample,
    designation: designations.sample,
    email: Faker::Internet.unique.email,
    encrypted_password: Devise::Encryptor.digest(Employee, "123456"),
    active: true,
    created_at: Time.current,
    updated_at: Time.current,
    confirmed_at: Time.current,
    jti: SecureRandom.uuid
  }

  if (i + 1) % batch_size == 0
    Employee.insert_all(employees)
    employees = []

    puts "Inserted #{i + 1} / #{total} employees"
  end
end

Employee.insert_all(employees) if employees.any?

puts "✅ Done inserting #{total} employees"
