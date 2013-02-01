#coding: utf-8
require 'csv'
require 'iconv'
class EventsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin_or_teacher?
  # GET /events
  # GET /events.json


  def index
    event_queries = {}
    stu_queries = {}
    cur_page = 1
    per_page = 8
    rule_cate = ""
    @page_count = 0

    #当有查询参数的时候
    if params[:event]
      if !params[:event][:start].blank? && !params[:event][:end].blank?
        start_time = params[:event][:start] + " 00:00:00"
        end_time = params[:event][:end] + " 23:59:59"
        event_queries.merge!(:created_at=>start_time..end_time)
      end
      #当有违纪类型作为筛选条件的时候
      event_queries.merge!({:rule_type=>params[:event][:rule_type]}) if !params[:event][:rule_type].blank?
      stu_queries.merge!({:grade=>params[:event][:grade]}) if !params[:event][:grade].blank?
      stu_queries.merge!({:class_num=>params[:event][:class_num]}) if !params[:event][:class_num].blank?
      stu_queries.merge!({:name=>params[:event][:stu_name]}) if !params[:event][:stu_name].blank?
      stu_queries.merge!({:grade=>1..6})
      cur_page = params[:page]
      rule_cate = params[:event][:rule_cate] if !params[:event][:rule_cate].blank?
      
      #当上一个操作是删除的时候
    elsif session[:from_destory] == "yes"
      event_queries = session[:event_queries]
      stu_queries = session[:stu_queries]
      cur_page = session[:page]
      rule_cate =  session[:rule_cate]
      session[:from_destory] = "no"
    else
      #其他时候
      event_queries = {:created_at=>Time.now.midnight..(Time.now.midnight + 1.day)}
      cur_page = params[:page]
    end


    #检查一下当前页数是否因为删除操作而需要-1
    @events = case rule_cate
    when "n"  then Event.normal
    when "s" then  Event.serious
    when "l" then Event.leave
    when "late" then Event.late
    else Event
    end

    @page_count = @events.includes(:student).where(
      :students=>stu_queries,
      :events=>event_queries
    ).count

    if cur_page && (@page_count.to_f / per_page.to_f) == (cur_page.to_i - 1).to_f
      cur_page = cur_page.to_i - 1
    end

    if @page_count > 0

      @events = @events.includes(:student).where(
        :students=>stu_queries,
        :events=>event_queries
      ).paginate(
        :page => cur_page,
        :per_page =>per_page
      )
    end
    
    #保存查询数据。在删除操作完成后，可以恢复之前的查询结果。
    session[:stu_queries] = stu_queries
    session[:event_queries] = event_queries
    session[:page] = cur_page
    session[:rule_cate] = rule_cate

    respond_to do |format|
      format.html {}
      format.json { render json: @events }
      format.csv do
        csv_string = CSV.generate do |csv|
          # header row
          csv << ["学号", "学生", "班别","事件类型", "记录时间"]
          # data rows
          @events.each do |event|
            student = event.student
            csv << [" " + student.num  + " ",
              student.name,
              student.class_info,
              Event.format_rule_type(event.rule_type),
              event.created_at.strftime("%y-%m-%d %I:%M%p")]
          end
        end
        # send it to the browsah
        send_data csv_string.encode("GB18030"),
          :type => 'text/csv; charset=GB18030; header=present',
          :disposition => "attachment; filename=#{DateTime.now.strftime("%y-%m-%d %I:%M%p")}.csv"
      end
    end
    
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html {
        session[:from_destory]="yes"
        redirect_to :action=>"index"
      }
      format.json { head :ok }
    end
  end

  def statistics
    @baihua_class_list = Student::GRADE_LIST
    @times = [["本周",Time.now.end_of_week - 6.day,Time.now.end_of_week],
      ["本月","#{Time.now.year}-#{Time.now.strftime("%m")}-01","#{Time.now.year}-#{Time.now.strftime("%m")}-31"],
      ["本学年","#{Time.now.year}-01-01","#{Time.now.year}-12-31"]
    ]
  end

  def period
    if params[:event] && !params[:event][:start].blank? && !params[:event][:end].blank?
      @start_time = params[:event][:start] + " 00:00:00"
      @end_time = params[:event][:end] + " 23:59:59"

      events = case params[:event][:rule_cate]
      when "n"  then Event.normal
      when "s" then  Event.serious
      when "l" then Event.leave
      when "late" then Event.late
      else
      end
      
      @result = []
      Student::GRADE_LIST.each do |cur_grade|
        1.upto(Student.class_list(cur_grade[1])) do|class_num|
          @result << {
            :times=>events.includes(:student).where(
              :students=>{
                :grade=>cur_grade[1],
                :class_num=>class_num},
              :created_at =>@start_time..@end_time).count,
            :grade=>cur_grade,
            :class_num=>class_num
          }
        end
      end
    end

    respond_to do |format|
      format.html {}
      format.csv do
        csv_string = CSV.generate do |csv|
          # header row
          csv << ["班级","由#{params[:event][:start]}至#{params[:event][:end]}的#{Event.format_rule_cate(params[:event][:rule_cate])}统计"]
          # data rows
          @result.each do |r|
            csv << ["#{r[:grade][0]}班#{r[:class_num].to_s}",r[:times]]
          end
        end
        # send it to the browsah
        send_data csv_string.encode("GB18030"),
          :type => 'text/csv; charset=GB18030; header=present',
          :disposition => "attachment; filename=#{DateTime.now.strftime("%y-%m-%d %I:%M%p")}.csv"
      end
    end
  end

  def bulk_delete
    if params[:events]
      chosen = []
      params[:events][:chosen].each do |e|
        if e[1] == "1"
          chosen << e[0]
        end
      end

      Event.delete(chosen)

      respond_to do |format|
        format.html {
          session[:from_destory]="yes"
          redirect_to :action=>"index"
        }
        format.json { head :ok }
      end
    end
    
  end

end
