#coding: utf-8
module ApplicationHelper
  def back_url
    request.env["HTTP_REFERER"] || '/'
  end

  def user_role_list
    return User::USER_ROLE_LIST
  end
end
