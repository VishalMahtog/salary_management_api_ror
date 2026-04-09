class AddFieldsToEmployees < ActiveRecord::Migration[8.1]
  def change
    add_column :employees, :full_name, :string
    add_column :employees, :job_title, :string
    add_column :employees, :country, :string
    add_column :employees, :salary, :float
    add_column :employees, :role, :integer, default: 0
    add_column :employees, :designation, :string
    add_column :employees, :active, :boolean, default: true
  end
end
