#coding: utf-8
class Student < ActiveRecord::Base
  validates :name, :num, :grade,:class_num,:presence=>{:message=>"不能为空"}
  has_attached_file :avatar,
    :withy => false ,
    :styles => { :medium => "275x300>",
    :thumb => "50x50>" }
  has_many :events,:dependent => :destroy
  belongs_to :bed
  #before_create :randomize_file_name
  before_update :check_avatar
  after_destroy :free_room
  after_create :lock_room
  
  GRADE_LIST = [["七年级",1],["八年级",2],["九年级",3],["高一",4],["高二",5],["高三",6]]
  SEX_LIST = [["男",1],["女",0]]

  def class_info
    "#{grade_name}(#{self.class_num})班"
  end
  
  def room_info
    return_vale = ""
    if self.bed
      return_vale = "#{self.bed.room.num}室#{self.bed.num}床"
    end
    return return_vale
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
    self.grade = (GRADE_LIST.find{|s| s[0] == value})[1] if GRADE_LIST.assoc(value)
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

  def self.clist(grade)
    max_class = self.find(:first,:conditions=>{:grade=>grade},:order=>("class_num desc"))
    if max_class
      return max_class.class_num
    else
      return 1
    end
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
  
  def free_room
    self.bed.update_attributes(:status=>4) if self.bed
  end
  
  def lock_room
    self.bed.update_attributes(:status=>1) if self.bed
  end
end
