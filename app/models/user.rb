class User < ApplicationRecord
  has_many :user_events
  has_many :user_tasks
  has_many :events, through: :user_events
  has_many :tasks, through: :user_tasks

  has_secure_password

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def self.find_or_create_from_auth_hash(auth)
		where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
			user.provider = auth.provider
			user.uid = auth.uid
			user.first_name = auth.info.first_name
			user.last_name = auth.info.last_name
			user.email = auth.info.email
			user.save!
    end
  end

end
