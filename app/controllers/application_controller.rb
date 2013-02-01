#coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def admin_or_teacher?
    permission_denied unless current_user.role == 1 or current_user.role == 2
  end

  def admin?
    permission_denied unless current_user.role == 1
  end

  def permission_denied
    respond_to do |format|
      format.html do
        #Put your domain name here ex. http://www.example.com
        domain_name = "http://localhost"
        http_referer = session[:refer_to]
        if http_referer.nil?
          http_referer = ( session[:refer_to] || domain_name )
        end
        flash[:notice] = "你没有权限进行操作."
        #The [0..20] represents the 21 characters in http://localhost:3000
        #You have to set that to the number of characters in your domain name
        if http_referer[0..20] != domain_name
          session[:refer_to] = nil
          redirect_to '/'
        else
          redirect_to_referer_or_default('/')
        end
      end
      format.xml do
        headers["Status"]           = "Unauthorized"
        headers["WWW-Authenticate"] = %(Basic realm="Web Password")
        render :text => "You don't have permission to complete this action.", :status => '401 Unauthorized'
      end
    end
  end

  def redirect_to_referer_or_default(default)
    redirect_to(session[:refer_to] || default)
    session[:refer_to] = nil
  end
  
  def times
    if Time.now.month > 1 && Time.now.month < 8
      term_start = "#{Time.now.year}-02-01"
      term_end = "#{Time.now.year}-07-31"
    elsif Time.now.month < 2
      term_start = "#{Time.now.year - 1.year}-09-01"
      term_end = Time.now.strftime("%Y-%m%d")
    else
      term_start = "#{Time.now.year}-09-01"
      term_end = Time.now.strftime("%Y-%m%d")
    end
    
    times = [
      ["本月",("#{Time.now.year}-#{Time.now.strftime("%m")}-01")..("#{Time.now.year}-#{Time.now.strftime("%m")}-31")],
      ["本学期",term_start..term_end]
    ]
    
    return times
  end
  
end
