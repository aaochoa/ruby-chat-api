class Conversation < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy

  validates :title, presence: true
  before_validation :set_default_title, on: :create

  scope :active, -> { where(deleted_at: nil) }

  def soft_delete(user)
    update(deleted_at: Time.current, deleted_by: user.id)
  end

  private
    def set_default_title
      self.title ||= "New Conversation #{user.conversations.count + 1}"
    end
end
