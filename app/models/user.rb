# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :project_memberships
  has_many :projects, through: :project_memberships

  has_many :reported_bugs, class_name: "Bug", foreign_key: :reporter_id
  has_many :assigned_bugs, class_name: "Bug", foreign_key: :assignee_id

  has_many :created_projects, class_name: "Project", foreign_key: :creator_id

  # Virtual attribute for role selection during signup
  attr_accessor :selected_role
  attr_accessor :role_password

  validate :validate_role_password, on: :create

  private

  def validate_role_password
    return if selected_role.blank?
    
    # Debug output - you can check your logs to see what's being received
    Rails.logger.debug "Selected role: #{selected_role.inspect}"
    Rails.logger.debug "Role password: #{role_password.inspect}"
    
    # Define special passwords for each role
    special_passwords = {
      "Manager" => "manager123",
      "Developer" => "developer123",
      "QA" => "qa123"
    }

    expected_password = special_passwords[selected_role]
    
    if expected_password.blank?
      errors.add(:selected_role, "is invalid - received: #{selected_role}")
    elsif role_password != expected_password
      errors.add(:role_password, "is incorrect for the selected role")
    end
  end
end