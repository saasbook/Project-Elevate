class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  def self.admin_update_membership_to(curr_user)
    statuses = ['Club Member', 'Coach', 'Manager']
    statuses.delete(curr_user.membership)
    statuses_blank = statuses.map{|c| [c, c]}.prepend(['Select...', nil])
    return statuses_blank
  end

  def self.manager_update_membership_to(curr_user)
    statuses = ['Club Member', 'Coach']
    statuses.delete(curr_user.membership)
    statuses_blank = statuses.map{|c| [c, c]}.prepend(['Select...', nil])
    return statuses_blank
  end
      
  def self.coaches
    return User.select(:id, :email, :name).where(:membership => ["Coach"])
  end

  def self.all_users_except_admin
    return User.select(:id, :name, :email, :membership).where(:membership => ["Club Member", "Manager", "Coach"])
  end

  def self.manager_users_view
    return User.select(:id, :name, :email, :membership).where(:membership => ["Club Member", "Coach"])
  end

  def get_calendar
    if self.membership == "Club Member" or self.membership == "Coach"
      @calendars = Calendar.all.where(:UserId => [self.id, nil]).where("start_time > ?", Time.now.beginning_of_day).order(:start_time)
    else
      @calendars = Calendar.all.where("start_time > ?", Time.now.beginning_of_day).order(:start_time)
    end
  end
end
