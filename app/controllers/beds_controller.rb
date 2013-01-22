#coding: utf-8
class BedsController < ApplicationController
  # GET /beds
  # GET /beds.json
  def index
    @beds = Bed.paginate(:page => params[:page], :per_page =>10)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @beds }
    end
  end

  # GET /beds/1
  # GET /beds/1.json
  def show
    @bed = Bed.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bed }
    end
  end

  # GET /beds/new
  # GET /beds/new.json
  def new
    @bed = Bed.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bed }
    end
  end

  # GET /beds/1/edit
  def edit
    @bed = Bed.find(params[:id])
    
    if @bed.room
      @current_floor = @bed.room.floor
    end
  end

  # POST /beds
  # POST /beds.json
  def create
    @bed = Bed.new(params[:bed])

    respond_to do |format|
      if @bed.save
        format.html { redirect_to beds_url, notice: '床位新增成功.' }
        format.json { render json: @bed, status: :created, location: @bed }
      else
        format.html { render action: "new" }
        format.json { render json: @bed.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /beds/1
  # PUT /beds/1.json
  def update
    @bed = Bed.find(params[:id])

    respond_to do |format|
      if @bed.update_attributes(params[:bed])
        format.html { redirect_to beds_url, notice: '床位修改成功.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @bed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beds/1
  # DELETE /beds/1.json
  def destroy
    @bed = Bed.find(params[:id])
    @bed.destroy

    respond_to do |format|
      format.html { redirect_to beds_url }
      format.json { head :ok }
    end
  end
  
  protected
end
