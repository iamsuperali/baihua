#coding: utf-8
module HomeHelper

  def grade_list
    return Student::GRADE_LIST
  end

  def rule_type_list
    return Event::RULE_LIST
  end

  def sex_list
    return Student::SEX_LIST
  end

  def format_sex(sex)
    (sex ==1 || sex ==0) ?  (Student::SEX_LIST.find{|s| s[1] == sex})[0] : "?"
  end
  
  def format_bed_status(status)
    (status ==1 || status ==2 || status==3 || status==4) ?  (Bed::STATUS_LIST.find{|s| s[1] == status})[0] : "?"
  end

end
