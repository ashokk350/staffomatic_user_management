class User < ApplicationRecord
  has_secure_password

  has_many :archive_user_histories

  validates :email,
    presence: true,
    uniqueness: true

  enum status: { archived: 'archived', un_archived: 'un-archived'}
end
