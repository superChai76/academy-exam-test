class Quest < ApplicationRecord
  validates :content, presence: true
  scope :done, -> { where(done: true) }
  scope :pending, -> { where(done: false) }
end
