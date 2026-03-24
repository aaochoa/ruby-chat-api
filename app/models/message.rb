class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :sender, class_name: 'User'

  has_many :message_recipients, dependent: :destroy
  has_many :receivers, through: :message_recipients, source: :user

  has_one_attached :media

  validates :body, presence: true, unless: -> { media.attached? }
end
