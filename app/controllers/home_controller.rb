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
  
  def dormitory
    
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
  
  def dormitory_search
    @student = Student.find(:first,:conditions => ["name = ? or num = ?",params[:keyword],params[:keyword]])
  end
  
  def change_dormitory_status
    @student = Student.find(params[:id])

    if params[:status]
      @student.bed.status = params[:status]
    end
    
    if params[:events]
      for item_hash in params[:events]
        #chech_box没有选中的时候，提交的值为"0"
        if item_hash[:rule_type] && item_hash[:rule_type] !="0"
          @student.events << Event.create(:rule_type=>item_hash[:rule_type],
            :remark=>item_hash[:remark])
        end
      end
    end
    
    
    respond_to do |format|
      if @student.bed.save
        format.html { redirect_to "/home/dormitory", notice: '<div id="success"></div>'}
      else
        format.html { redirect_to "/home/dormitory", notice: '操作失败!' }
      end
    end
  end

  protected

  def validation_ip
    if request.remote_ip !="127.0.0.1"
      redirect_to "/events"
      return false
    end
  end
end
