#coding: utf-8
class Room < ActiveRecord::Base
  FLOOR_LIST = [
    ["一楼",1],
    ["二楼",2],
    ["三楼",3],
    ["四楼",4]
  ]
  
  has_many :beds
end
