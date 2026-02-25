class ProjectMembership < ApplicationRecord
  belongs_to :user
  belongs_to :project

  enum :role, { manager: 0, developer: 1, qa: 2 }
  validates :role, presence: true
end
