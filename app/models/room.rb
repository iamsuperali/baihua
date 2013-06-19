#coding: utf-8
class Room < ActiveRecord::Base
  after_create :create_beds
  FLOOR_LIST = [
    ["一楼",1],
    ["二楼",2],
    ["三楼",3],
    ["四楼",4]
  ]
  
  has_many :beds,:dependent => :destroy
  
  private
  def create_beds
    1.upto(10) do |x|
      self.beds << Bed.new(:num=>x)
    end
    
    self.save
  end
  
end
