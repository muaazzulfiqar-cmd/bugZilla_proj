class Project < ApplicationRecord
  belongs_to :creator, class_name: "User"

  has_many :project_memberships, dependent: :destroy
  has_many :users, through: :project_memberships

  has_many :bugs, dependent: :destroy

  validates :name, presence: true
end