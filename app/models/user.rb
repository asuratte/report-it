class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum role: [:resident, :official, :admin]
  validates :first_name, :last_name, :address1, :city, :state, :zip, :phone, :username, presence: true
  validates_format_of :zip, :with => /\A\d{5}(-\d{4})?\z/, :message => "should be a valid US zip code. ex: 12345 or 12345-1234"
  validates_format_of :phone,  with: /\A(1-)?\d{3}-\d{3}-\d{4}\z/, :message => "should be a valid phone number with dashes. ex: 111-222-3333, 1-333-444-5555"
  validates :username, length: {minimum: 6, maximum: 30}, uniqueness: true
  has_many :reports

  def active_for_authentication?
    super && self.active
  end

  def is_resident?
    return self.role == 'resident'
  end

  def is_official?
    return self.role == 'official'
  end

  def is_admin?
    return self.role == 'admin'
  end

  def is_active?
    return self.active
  end

end
