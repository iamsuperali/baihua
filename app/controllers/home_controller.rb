#coding: utf-8
require 'rubygems'
require 'barby'
require 'barby/barcode/code_39'
require 'barby/outputter/svg_outputter'
    
class HomeController < ApplicationController
  before_filter :authenticate_user!
  layout "home"
  def index
  end

  def search
    	
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
    
    @times = [
      ["本月",("#{Time.now.year}-#{Time.now.strftime("%m")}-01")..("#{Time.now.year}-#{Time.now.strftime("%m")}-31")],
      ["本学期",term_start..term_end]
    ]
    @student = Student.find(:first,:conditions => ["name = ? or num = ?",params[:keyword],params[:keyword]])
  end

  protected

  def validation_ip
    if request.remote_ip !="127.0.0.1"
      redirect_to "/events"
      return false
    end
  end
end
