#coding: utf-8
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         #:registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,:username,:role
  validates_uniqueness_of   :username, :case_sensitive => false
  USER_ROLE_LIST = [["管理员",1],["班主任",2],["保卫科",3]]

  def timeout_in
    if self.role == 1
      2.days
    else
      1.year
    end
  end
end
