#coding: utf-8
class Event < ActiveRecord::Base
  belongs_to :student

  scope :normal,where("rule_type != 16 and rule_type != 2 and  rule_type != 3
 and rule_type != 4  and rule_type != 5")

  scope :serious,where("rule_type == 16")
  scope :leave,where("rule_type > 1 and  rule_type < 6")
  scope :late,where("rule_type == 1")

  RULE_LIST = [
    ["返校迟到",1],
    ["病假",2],
    ["事假",3],
    ["病假离校",4],
    ["事假离校",5],
    ["没穿校服",6],
    ["发型不符合要求",7],
    ["指甲不符合要求",8],
    ["外带食物、饮料",9],
    ["没带书包",10],
    ["吸烟",11],
    ["打架",12],
    ["骑摩托回校",13],
    ["课上违纪",14],
    ["其他一般违纪",15],
    ["严重违纪",16],
    ["夜不归宿",17],
    ["违规用电",18],
    ["违反宿舍安全制度",19],
    ["不服从宿管员管理",20],
    ["不按作息时间休息  ",21],
    ["内务整理不规范",22],
    ["寻衅滋事",23],
    ["窃取他人财物",24],
    ["不文明行为",25],
    ["其他宿舍违纪",26]
  ]

  CATE_LIST = [
    ["迟到","late"],
    ["一般违纪","n"],
    ["严重违纪","s"],
    ["请假","l"]
  ]

  def self.format_rule_type(rule_type)
    (RULE_LIST.find{|s| s[1] == rule_type})[0]
  end

  def self.format_rule_cate(rule_cate)
    (Event::CATE_LIST.find{|s| s[1] == rule_cate})[0]
  end

end
