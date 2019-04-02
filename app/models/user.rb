class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable



  def self.all_users_except_admin
    return User.select(:nickname, :email, :membership).where(:membership => ["Club Member", "Manager", "Coach"])
  end

  def self.manager_users_view
    return User.select(:nickname, :email, :membership).where(:membership => ["Club Member", "Coach"])
  end

end
