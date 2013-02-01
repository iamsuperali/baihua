#coding: utf-8
class Student < ActiveRecord::Base
  scope :undergraduate,where("1=1")
  validates :name, :num, :grade,:class_num,:presence=>{:message=>"不能为空"}
  has_attached_file :avatar,
    :withy => false ,
    :styles => { :medium => "275x300>",
    :thumb => "50x50>" }
  has_many :events,:dependent => :destroy
  #before_create :randomize_file_name
  before_update :check_avatar

  GRADE_LIST = [["高一",4],["高二",5]]
  SEX_LIST = [["男",1],["女",0]]

  def class_info
    "#{grade_name}(#{self.class_num})班"
  end

  def grade_name
    grade_name = (GRADE_LIST.find{|s| s[1] == self.grade})
    if grade_name
      return grade_name[0]
    else
      "无年级"
    end
  end

  def grade_name=(value)
    self.grade = (GRADE_LIST.find{|s| s[0] == value})[1] if value == "高一" || value == "高二" || value == "高三"
  end

  def sex_text
    cur_sex_text = (SEX_LIST.find{|s| s[1] == self.sex})
    if cur_sex_text
      return cur_sex_text[0]
    else
      "?"
    end
  end

  def sex_text=(value)
    self.sex = (SEX_LIST.find{|s| s[0] == value})[1] if value == "男" || value == "女"
  end

  def rating

    normal_discipline_times = self.count_normal_discipline
    cur_rating = ""

    Rating.all.each  do |e|
      if e.lower_limit >= normal_discipline_times
        cur_rating = e
        break
      end
    end

    if self.count_serious_discipline > 0
      1.upto(self.count_serious_discipline)do |t|
        cur_rating = cur_rating.degrade
      end
    end

    return cur_rating.name
  end

  def count_normal_discipline
    self.events.normal.count
  end

  def count_serious_discipline
    self.events.serious.count
  end

  def self.class_list(grade)
    self.where(:grade => grade).order("class_num desc").first.class_num
  end


  private
  def randomize_file_name
    if avatar_file_name
    	extension = File.extname(avatar_file_name).downcase
    	self.avatar.instance_write(:file_name, "#{Time.now.strftime("%Y%m%d%H%M%S")}#{rand(1000)}#{extension}")
    end
  end

  def check_avatar
    randomize_file_name if self.avatar_file_name_changed?
  end

end
