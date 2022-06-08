class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum role: [:resident, :official, :admin]
  validates :first_name, :last_name, :address1, :city, :state, :zip, :phone, :username, presence: true
  
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
