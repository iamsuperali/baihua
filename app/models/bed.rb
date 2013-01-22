#coding: utf-8
class Bed < ActiveRecord::Base
  belongs_to :room
  has_one :student
  before_update :clean_ask_for_leave
  
  
  STATUS_LIST = [
    ["未归",1],
    ["就寝",2],
    ["请假",3],
    ["未分配",4]
  ]
  
  private
  def clean_ask_for_leave
    if self.status == 4
      self.ask_for_leave_begin = nil
      self.ask_for_leave_end = nil
    end
  end
end
