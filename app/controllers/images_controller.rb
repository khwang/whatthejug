class ImagesController < ApplicationController
  
  before_filter :authenticate_admin!, :only => [:review]

  # GET /images
  # GET /images.json
  def index
    @images = Image.all :conditions => { :unreviewed => false }

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @images }
    end
  end

  # GET /random
  # GET /random.json

  def random
    @images = Image.where(unreviewed: false).order("RANDOM()")

    respond_to do |format|
      format.html { render "index" }
      format.json { render json: @images }
    end
  end

  # GET /images/1
  # GET /images/1.json
  def show
    @image = Image.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @image }
    end
  end

  # GET /images/new
  # GET /images/new.json
  def new
    @image = Image.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @image }
    end
  end

  # GET /images/1/edit
  def edit
    @image = Image.find(params[:id])
  end

  # POST /images
  # POST /images.json
  def create
    params[:images].each do |image|
      @image = Image.new(image)
      @image.save
    end

    respond_to do |format|
      @images = Image.where(unreviewed: false).all
      format.html { render action: "index" }
    end

  end

  # PUT /images/1
  # PUT /images/1.json
  def update
    @image = Image.find(params[:id])

    tags = params[:image].delete :tags

    @image.tag_list = tags

    respond_to do |format|
      if @image.update_attributes(params[:image])
        format.html { redirect_to @image, notice: 'Image was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image = Image.find(params[:id])
    @image.destroy

    respond_to do |format|
      format.html { redirect_to images_url }
      format.json { head :no_content }
    end
  end

  # GET /images/tag_cloud
  def tag_cloud
    @tags = Image.tag_counts
  end

  # GET /search?query=tags

  def search
    query = params[:query]
    @images = Image.tagged_with(query.split(","))

    respond_to do |format|
      format.html { render "index" }
      format.json { render json: @images }
    end

  end

  def review
    @images = Image.where(:unreviewed => true).all

    respond_to do |format|
      format.html { render "index" }
    end
  end
end
