class User < ApplicationRecord
  has_many :user_events, dependent: :destroy
  has_many :user_tasks, dependent: :destroy
  has_many :events, through: :user_events
  has_many :tasks, through: :user_tasks

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
  has_many :inverse_friends, through: :inverse_friendships, source: :user

  has_secure_password(validations: false)
  validates_presence_of :password, on: :create, unless: :other_provider?
  validates_confirmation_of :password, if: :password_present?
  validates :email, presence: true, on: :create, unless: :other_provider?
  validates :email, uniqueness: true
  validates :username, presence: true, on: :create, unless: :other_provider?
  validates :username, uniqueness: true

  after_create :assign_uniq_username?

  ###################################################################
  # Checks if the user's account was created through facebook, etc. #
  ###################################################################
  def other_provider?
    self.provider && self.uid
  end

  ################################################
  # Checks if the account has a password present #
  ################################################
  def password_present?
    self.password_digest
  end

  ######################################################################
  # Concatenates the user's first and last names to create a full name #
  ######################################################################
  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  ############################################################################
  # If a username is not present, it uses the first part of the user's email #
  ############################################################################
  def display_user_name
    self.username ? self.username : self.email.scan(/^[^@]*/)[0]
  end

  ###################################################
  # Assigns a randomly rengenerated unique username #
  ###################################################
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

  #######################################
  # Generates a username if not present #
  #######################################
  def generate_username
    "#{last_name_capped}.#{first_name_letter}.#{random_num}"
  end

  #######################################
  # Generates a random number up to 999 #
  #######################################
  def random_num
    Random.new.rand(1000)
  end

  #############################
  # Capitalizes the last name #
  #############################
  def last_name_capped
    self.last_name.capitalize
  end

  ##################################################
  # Capitalizes the first letter of the first name #
  ##################################################
  def first_name_letter
    self.first_name.scan(/\b[a-zA-Z]/)[0][0].capitalize
  end

  #######################################################
  # Finds a user by uid and provider from the auth hash #
  #######################################################
  def self.find_from_auth_hash(auth)
    where(provider: auth.provider, uid: auth.uid).first
  end

  ###################################################################
  # Creates a new user based on information gathered from auth hash #
  ###################################################################
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
