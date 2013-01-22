#coding: utf-8
module ApplicationHelper
  def back_url
    request.env["HTTP_REFERER"] || '/'
  end

  def user_role_list
    return User::USER_ROLE_LIST
  end
  
  def room_list(room_id)
    return_array = "<option value=0>...</option>"
    Room.all.each do |r|
      return_array += "<option value=#{r.id} class='#{r.floor}'"
      return_array += " selected='selected' " if room_id == r.id
      return_array += ">#{r.num}</option>"
    end

    return return_array.html_safe
  end
  
  def floor_options(floor)
    return_array = "<option value=0>...</option>"
    Room::FLOOR_LIST.each do |f|
      return_array += "<option value=#{f[1]}"
      return_array += " selected='selected' " if f[1] == floor
      return_array += ">#{f[0]}</option>"
    end
    
    return return_array.html_safe
  end
  
  def bed_options(bed_id)
    return_array = "<option value=0>...</option>"
    Bed.all.each do |b|
      unless b.student && b.id != bed_id
        return_array += "<option value=#{b.id}  class='#{b.room_id}'"
        return_array += " selected='selected' " if b.id == bed_id
        return_array += ">#{b.num}</option>"
      end
      
    end
    
    return return_array.html_safe
  end 

end
