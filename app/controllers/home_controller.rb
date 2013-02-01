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
    	
    @times = times
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
