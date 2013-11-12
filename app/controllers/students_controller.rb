#coding: utf-8
require 'rubygems'
require 'barby'
require 'barby/barcode/code_39'
require 'barby/outputter/svg_outputter'
require 'find'
require 'csv'
require 'iconv'

class StudentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin_or_teacher?,:except =>:add_events
  # GET /students
  # GET /students.json
  def index
    if params[:student]
      query_hash = {}
      query_hash.merge!(:num => params[:student][:num]) if !params[:student][:num].blank?
      query_hash.merge!(:name => params[:student][:name]) if !params[:student][:name].blank?
      query_hash.merge!(:class_num => params[:student][:class]) if !params[:student][:class].blank?
      query_hash.merge!(:grade => params[:student][:grade]) if !params[:student][:grade].blank?
    else
      query_hash = "grade > 0"
    end
    
    @students = Student.where(query_hash)
    
    if params[:barcode]
      render :template=>"/students/barcode",:layout=>false
    else
      respond_to do |format|
        format.html {@students = @students.paginate(:page => params[:page], :per_page =>8)}
        format.json { render json: @students }
        format.csv do
          first_row = []
          csv_string = CSV.generate do |csv|
            # header row
            first_row += ["学号", "学生", "班别"]

            Event::RULE_LIST.each do |r|
              first_row += [r[0]]
            end

            first_row += ["评级"]
            csv << first_row
            # data rows

            @students.each do |s|
              data_row = []
              data_row += [" " + s.num  + " ",
                s.name,
                s.class_info]

              Event::RULE_LIST.each do |r|
                data_row << s.events.where(:rule_type=>r[1]).count
              end

              data_row << s.rating

              csv << data_row
            end
          end
          # send it to the browsah
          send_data csv_string.encode("GB18030"),
            :type => 'text/csv; charset=GB18030; header=present',
            :disposition => "attachment; filename=#{DateTime.now.strftime("%y-%m-%d %I:%M%p")}.csv"
        end
      end
    end
    
    
  end

  # GET /students/1
  # GET /students/1.json
  def show
    @student = Student.find(params[:id])
    @times = times


    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @student }
    end
  end

  # GET /students/new
  # GET /students/new.json
  def new
    @student = Student.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @student }
    end
  end

  # GET /students/1/edit
  def edit
    @student = Student.find(params[:id])
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(params[:student])

    respond_to do |format|
      if @student.save
        format.html { redirect_to @student, notice: '学生资料创建成功.' }
        format.json { render json: @student, status: :created, location: @student }
      else
        format.html { render action: "new" }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /students/1
  # PUT /students/1.json
  def update
    @student = Student.find(params[:id])

    respond_to do |format|
      if @student.update_attributes(params[:student])
        format.html { redirect_to @student, notice: '学生资料更新成功.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_events
    @student = Student.find(params[:id])

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
      if @student.save
        format.html { redirect_to "/", notice: '<div id="success"></div>'}
      else
        format.html { redirect_to "/", notice: '操作失败!' }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student = Student.find(params[:id])
    @student.destroy
    
    respond_to do |format|
      format.html { 
        redirect_to :back and return unless request.referrer == students_path(@student)
        redirect_to students_url
      }
      format.json { head :ok }
    end
  end

  def import
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def upload_excel
    counter = 0
    unless params[:post].blank?
      Spreadsheet.client_encoding = "UTF-8"
      uploaded_io = params[:post][:attached]
      book = Spreadsheet.open(uploaded_io.tempfile)
      sheet0 = book.worksheet 0
      
      sheet0.each  1 do |row|
        student = Student.find_or_create_by_num(row[0])
        student.update_attributes(:name=>row[1].strip,
          :sex_text=>(row[2] ? row[2].strip : ""),
          :enter_tag=>row[3],
          :grade_name=>(row[4] ? row[4].strip : ""),
          :class_num=>row[5])
        counter +=1 if student.save
      end
    end

    respond_to do |format|
      format.html { redirect_to students_url ,notice: "更新#{counter}个学生资料"}
      format.json { head :ok }
    end
  end

  def update_photo
    counter = 0
    unless params[:photo_path].blank?
      Find.find(params[:photo_path]) do |path|
        if File.fnmatch("*.j*g",path)
          stu_num = File.basename(path,".j*g")[/[0-9]+/]
          cur_stu = Student.find_by_num(stu_num)
          if cur_stu
            new_path = File.dirname(path) + "/" + cur_stu.num + ".jpg"
            File.rename(path,new_path)
            begin
              cur_stu.avatar = File.new(new_path,"r")
              counter +=1 if cur_stu.save!
            end
          end
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to students_url ,notice: "更新#{counter}个学生图片"}
      format.json { head :ok }
    end
  end

  def upgrade

    Student.transaction do
      Student.update_all "grade = 0","grade = 3"
      Student.update_all "grade = 3","grade = 2"
      Student.update_all "grade = 2","grade = 1"
    end

    respond_to do |format|
      format.html { redirect_to "/students", notice: '学生资料升级成功.' }
      format.json { head :ok }
    end

  end

  def degrade

    Student.transaction do
      Student.update_all "grade = 4","grade = 0"
      Student.update_all "grade = 0","grade = 1"
      Student.update_all "grade = 1","grade = 2"
      Student.update_all "grade = 2","grade = 3"
      Student.update_all "grade = 3","grade = 4"
    end

    respond_to do |format|
      format.html { redirect_to "/students", notice: '学生资料降级成功.' }
      format.json { head :ok }
    end

  end
  
  def update_state
    Student.transaction do
      Student.update_all "state = 1","grade != 0"
      Student.update_all "state = 0","grade == 0"
    end
  end
  
  def bulk_delete
    if params[:students]
      chosen = []
      params[:students][:chosen].each do |e|
        if e[1] == "1"
          chosen << e[0]
        end
      end

      Student.delete(chosen)

      respond_to do |format|
        format.html {
          redirect_to :back and return unless request.referrer == students_path(@student)
          redirect_to students_url
        }
        format.json { head :ok }
      end
    end
    
  end

end
