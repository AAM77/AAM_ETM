class User < ApplicationRecord
  has_many :user_events
  has_many :user_tasks
  has_many :events, through: :user_events
  has_many :tasks, through: :user_tasks
  has_many :friendships
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"

  has_secure_password(validations: false)
  validates_presence_of :password, on: :create, unless: :other_provider?
  validates_confirmation_of :password, if: :password_present?
  validates :email, presence: true, on: :create, unless: :other_provider?
  validates :email, uniqueness: true
  validates :username, presence: true, on: :create, unless: :other_provider?
  validates :username, uniqueness: true

  after_create :assign_uniq_username?

  def other_provider?
    self.provider && self.uid
  end

  def password_present?
    self.password_digest
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def display_user_name
    self.username ? self.username : self.email.scan(/^[^@]*/)[0]
  end

  def assign_uniq_username?
    if self.username.nil?
      generated_username = generate_username
      if User.find_by(username: generated_username)
        assign_uniq_username
      else
        self.username = generated_username
        self.save
      end
    end
  end

  def generate_username
    "#{last_name_capped}.#{first_name_letter}.#{random_num}"
  end

  def random_num
    Random.new.rand(1000)
  end

  def last_name_capped
    self.last_name.capitalize
  end

  def first_name_letter
    self.first_name.scan(/\b[a-zA-Z]/)[0][0].capitalize
  end

  def self.find_from_auth_hash(auth)
    where(provider: auth.provider, uid: auth.uid).first
  end

  def self.new_from_auth_hash(auth)
    User.new(
      provider: auth.provider,
			uid: auth.uid,
      username: auth.info.username || auth.info.nickname,
			first_name: auth.info.first_name || auth.info.name.scan(/^[^\s]*/)[0],
			last_name: auth.info.last_name || auth.info.name.scan(/\s(.*)/)[0][0],
			email: auth.info.email,
    )
  end

end
