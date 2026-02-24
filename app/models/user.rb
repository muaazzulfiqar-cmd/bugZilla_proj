# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :project_memberships, dependent: :destroy
  has_many :projects, through: :project_memberships
  has_many :reported_bugs, class_name: "Bug", foreign_key: :reporter_id, dependent: :destroy
  has_many :assigned_bugs, class_name: "Bug", foreign_key: :assignee_id, dependent: :nullify
  has_many :created_projects, class_name: "Project", foreign_key: :creator_id, dependent: :nullify

  enum :global_role, { employee: 0, admin: 1 }

  attr_accessor :selected_global_role
  attr_accessor :role_password

  validate :validate_global_role_password, on: :create

  def admin?
    global_role == "admin"
  end

  def employee?
    global_role == "employee"
  end

  private

  def validate_global_role_password
    return if selected_global_role.blank?
    
    special_passwords = {
      "employee" => "employee123",
      "admin" => "admin123"
    }

    normalized_role = selected_global_role.to_s.downcase
    expected_password = special_passwords[normalized_role]
    
    if expected_password.blank?
      errors.add(:selected_global_role, "is invalid")
    elsif role_password != expected_password
      errors.add(:role_password, "is incorrect for the selected global role")
    else
      self.global_role = normalized_role
    end
  end
end