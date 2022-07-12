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
  has_many :comments
  has_many :followed_reports, dependent: :destroy
  has_many :confirmations, dependent: :destroy

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

  def self.get_username(user_id)
    User.find(user_id)
  end

  # Checks if a report has been followed by the user
  def has_followed?(report)
    return self.followed_reports.exists?(report_id: report.id)
  end

  # Creates a followed-report for given report. If the followed-report exists, it removes it.
  def follow(report)
    if self.has_followed?(report)
      self.followed_reports.find_by(report_id: report.id).destroy
    else
      self.followed_reports.create(report_id: report.id)
    end
  end

  # Checks if a report has been confirmed by the user
  def has_confirmed?(report)
    return self.confirmations.exists?(report_id: report.id)
  end

  # Creates a report confirmation for the given report, unless the user has already confirmed it or created the report
  def confirm(report)
    unless self.has_confirmed?(report) || self.reports.exists?(id: report.id)
      self.confirmations.create(report_id: report.id)
    end
  end

end
