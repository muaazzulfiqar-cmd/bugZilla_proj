# app/models/bug.rb
class Bug < ApplicationRecord
  belongs_to :project
  belongs_to :reporter, class_name: "User"
  belongs_to :assignee, class_name: "User", optional: true

  has_many_attached :screenshots, dependent: :destroy


  enum :status, { open: 0, in_progress: 1, resolved: 2, closed: 3 }
  enum :priority, { low: 0, medium: 1, high: 2 }

  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :by_priority, ->(priority) { where(priority: priority) if priority.present? }

  validates :title, presence: true
  validates :status, presence: true
end