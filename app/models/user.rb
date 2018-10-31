class User < ApplicationRecord
  has_many :user_events, dependent: :destroy
  has_many :user_tasks, dependent: :destroy
  has_many :events, through: :user_events, dependent: :destroy
  has_many :tasks, through: :user_tasks, dependent: :destroy

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships, dependent: :destroy
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id", dependent: :destroy
  has_many :inverse_friends, through: :inverse_friendships, source: :user, dependent: :destroy

  has_secure_password(validations: false)
  validates_presence_of :password, on: :create, unless: :other_provider?
  validates_confirmation_of :password, if: :password_present?
  validates :email, presence: true, on: :create, unless: :other_provider?
  validates :email, uniqueness: true
  validates :username, presence: true, on: :create, unless: :other_provider?
  validates :username, uniqueness: true

  after_create :assign_uniq_username
  after_create :capitalize_first_and_last_name
  after_create :capitalize_username
  after_create :capitalize_email
  before_destroy :unfriend_all
  before_destroy :delete_events_user_created

  ###################################################################
  # Checks if the user's account was created through facebook, etc. #
  # Used for: conditional user validations                          #
  ###################################################################
  def other_provider?
    self.provider && self.uid
  end

  ################################################
  # Checks if the account has a password present #
  # Used for: conditional user validations       # // Necessary? //
  ################################################
  def password_present?
    self.password_digest
  end

  ##########################################
  # Case Insensitive search for a username #
  ##########################################
  def self.search_for_username(user_name)
    self.where("LOWER(username) = ?", user_name.downcase).first
  end

  ########################################
  # Case Insensitive search for an email #
  ########################################
  def self.search_for_email(e_mail)
    self.where("LOWER(email) = ?", e_mail.downcase).first
  end

  ##################################################
  # Destroys Friendships associated with this user #
  ##################################################
  def unfriend_all
    Friendship.where(user_id: self.id).each { |f| f.destroy }
    Friendship.where(friend_id: self.id).each { |f| f.destroy }
  end

  ########################################
  # Destroys Events Created by this User #
  ########################################
  def delete_events_user_created
    Event.where(admin_id: self.id).each { |f| f.destroy }
  end


  ########################################
  # Capitalizes the First and Last Names #
  ########################################
  def capitalize_first_and_last_name
    self.first_name = self.first_name.capitalize if self.first_name
    self.last_name = self.last_name.capitalize if self.last_name
    self.save
  end

  ############################
  # Capitalizes the Username #
  ############################
  def capitalize_username
    self.username = self.username.capitalize if self.username
    self.save
  end

  #########################
  # Capitalizes the Email #
  #########################
  def capitalize_email
    self.email = self.email.capitalize if self.email
    self.save
  end

  #########################
  # Displays Total Points #
  #########################
  def display_points
    self.total_points.round(2)
  end

  ######################################################################
  # Concatenates the user's first and last names to create a full name #
  ######################################################################
  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  ###################################################
  # Assigns a randomly rengenerated unique username #
  ###################################################
  def assign_uniq_username
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
  # Used for: assign_uniq_username      #
  #######################################
  def generate_username
    "#{self.first_name}.#{last_name_first_letter}.#{random_num}"
  end

  #######################################
  # Generates a random number up to 999 #
  # Used for: generate_username         #
  #######################################
  def random_num
    Random.new.rand(1000)
  end

  ##################################################
  # Capitalizes the first letter of the last name #
  # Used for: generate_username                    #
  ##################################################
  def last_name_first_letter
    self.first_name.scan(/\b[a-zA-Z]/)[0][0]
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

  #####################
  # Lists Friendships #
  #####################
  def friendships_list
    friends_list = []

    self.friendships.each do |friendship|
      friends_list << friendship
    end

    self.inverse_friendships.each do |inverse_friendship|
      friends_list << inverse_friendship
    end

    friends_list.uniq
  end


  ####################
  # Lists Friend IDs #
  ####################
  def friend_ids_list
    friends_ids_list = []

    self.friend_ids.each do |friend_id|
      friends_ids_list << friend_id
    end

    self.inverse_friend_ids.each do |inverse_friend_id|
      friends_ids_list << inverse_friend_id
    end

    friends_ids_list.uniq
  end


end
