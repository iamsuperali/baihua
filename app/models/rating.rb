#coding: utf-8
class Rating < ActiveRecord::Base
  def degrade
    next_grade = Rating.where("lower_limit > ?",self.lower_limit).first
    return next_grade ? next_grade : self
  end
end
